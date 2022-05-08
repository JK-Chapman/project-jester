extends KinematicBody2D

var speed = 150
var dash_speed = 400
var dash_duration = 0.1
var move_dir = Vector2(0, 0)
var life = 3

var anim_dir = "L"
var anim_mode = "Idle"

var index
var p_state
enum state {DEFAULT, MINIGAME_CONTROL, DEAD}

var punching = false
var punch_dir = Vector2(0,0)
var checked_stick = false

onready var sprite = $Sprite
onready var dash = $Dash

func init(index):
	self.index = index
	self.set_name("Player" + str(index))

func _physics_process(delta):
	var p_speed = dash_speed if dash.is_dashing() else speed
	MovementLoop(p_speed)
	
func _unhandled_input(event):
	if (!punching) and (Input.is_action_just_pressed("punch_l" + str(index)) || Input.is_action_just_pressed("punch_r" + str(index)) || Input.is_action_just_pressed("punch_u" + str(index)) || Input.is_action_just_pressed("punch_d" + str(index))):
		punching = true
		var x_axis = Input.get_joy_axis(index, JOY_AXIS_2)
		var y_axis = Input.get_joy_axis(index, JOY_AXIS_3)
		if abs(x_axis) < 0.28:
			x_axis = 0
		elif x_axis < 0:
			x_axis = floor(x_axis)
		else:
			x_axis = ceil(x_axis)

		if abs(y_axis) < 0.28:
			y_axis = 0
		elif y_axis < 0:
			y_axis = floor(y_axis)
		else:
			y_axis = ceil(y_axis)
		punch_dir = Vector2(x_axis, y_axis)
		if punch_dir != Vector2(0, 0):
			print(str(punch_dir))
			Attack()
			
	if (dash.can_dash) and (!dash.is_dashing()) and (Input.is_action_just_pressed("dash" + str(index))):
		move_dir.x = int(Input.is_action_pressed("move_right" + str(index))) - int(Input.is_action_pressed("move_left" + str(index)))
		move_dir.y = (int(Input.is_action_pressed("move_down" + str(index))) - int(Input.is_action_pressed("move_up" + str(index)))) / float(2)
		
		if (!(move_dir.x == 0 and move_dir.y == 0)):
			dash.start_dash($Sprite, $Sprite/dash_pos, dash_duration)


func _process(delta):
	AnimationLoop()
	

func MovementLoop(p_speed):
	if (!dash.is_dashing()):
		move_dir.x = int(Input.is_action_pressed("move_right" + str(index))) - int(Input.is_action_pressed("move_left" + str(index)))
		move_dir.y = (int(Input.is_action_pressed("move_down" + str(index))) - int(Input.is_action_pressed("move_up" + str(index)))) / float(2)
	var motion = move_dir.normalized() * p_speed
	move_and_slide(motion)

func AnimationLoop():
	var animation
	anim_mode = "Idle"
	
	if punching:
		anim_mode = "Punch"
		match punch_dir:
			Vector2(-1, 0):
				anim_dir = "L"
			Vector2(1, 0):
				anim_dir = "R"
			Vector2(0, 1):
				anim_dir = "D"
			Vector2(0, -1):
				anim_dir = "U"
			Vector2(-1, -1):
				anim_dir = "UL"
			Vector2(-1, 1):
				anim_dir = "DL"
			Vector2(1, -1):
				anim_dir = "UR"
			Vector2(1, 1):
				anim_dir = "DR"
	else:
		match move_dir:
			Vector2(-1, 0):
				anim_dir = "L"
			Vector2(1, 0):
				anim_dir = "R"
			Vector2(0, 0.5):
				anim_dir = "D"
			Vector2(0, -0.5):
				anim_dir = "U"
			Vector2(-1, -0.5):
				anim_dir = "UL"
			Vector2(-1, 0.5):
				anim_dir = "DL"
			Vector2(1, -0.5):
				anim_dir = "UR"
			Vector2(1, 0.5):
				anim_dir = "DR"
			
		if move_dir != Vector2(0, 0):
			anim_mode = "Run"
	
	animation = anim_mode + "_" + anim_dir
	get_node("AnimationPlayer").play(animation)
	
func Attack():
	yield(get_tree().create_timer(0.5), "timeout")
	punching = false
	anim_mode = "Idle"
	
func take_damage(damage):
	life -= damage
	print("DEBUG: Player has taken damage and now has " + str(life) + " life.")

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Hazard"):
		if dash.is_dashing(): return
		take_damage(body.damage)
		body.destroy()

func _on_PunchHitbox_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("left")


func _on_PunchHitboxRight_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("right")


func _on_PunchHitboxUp_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("up")


func _on_PunchHitboxDown_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("down")


func _on_PunchHitboxUpLeft_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("up_left")


func _on_PunchHitboxUpRight_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("up_right")


func _on_PunchHitboxDownLeft_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("down_left")


func _on_PunchHitboxDownRight_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("down_right")
