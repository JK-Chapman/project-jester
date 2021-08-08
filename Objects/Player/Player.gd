extends KinematicBody2D

var speed = 150
var move_dir = Vector2(0, 0)
var life = 3

var anim_dir = "L"
var anim_mode = "Idle"

var index
var p_state
enum state {DEFAULT, MINIGAME_CONTROL}

var punching = false
var punch_dir

func init(index):
	self.index = index
	self.set_name("Player" + str(index))
	self.p_state = state.DEFAULT

func _physics_process(delta):
	if p_state == state.DEFAULT:
		MovementLoop()
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("punch" + str(index)) && !punching:
		punching = true
		Attack()


func _process(delta):
	if p_state == state.DEFAULT:
		AnimationLoop()
	

func MovementLoop():
	move_dir.x = int(Input.is_action_pressed("move_right" + str(index))) - int(Input.is_action_pressed("move_left" + str(index)))
	move_dir.y = (int(Input.is_action_pressed("move_down" + str(index))) - int(Input.is_action_pressed("move_up" + str(index)))) / float(2)
	var motion = move_dir.normalized() * speed
	move_and_slide(motion)

func AnimationLoop():
	var animation
	anim_mode = "Idle"
	
	if punching:
		if get_node("Sprite").scale.x == 1:
			anim_dir = "R"
		elif get_node("Sprite").scale.x == -1:
			anim_dir = "L"
		anim_mode = "Punch"
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
			
		if move_dir != Vector2(0, 0):
			anim_mode = "Run"
	
	animation = anim_mode + "_" + anim_dir
	get_node("AnimationPlayer").play(animation)
	
func Attack():
	yield(get_tree().create_timer(0.326), "timeout")
	punching = false
	anim_mode = "Idle"
	
func take_damage(damage):
	life -= damage
	print("DEBUG: Player has taken damage and now has " + str(life) + " life.")

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Hazard"):
		take_damage(body.damage)
		body.destroy()


func _on_PunchHitbox_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("left")


func _on_PunchHitboxRight_body_entered(body):
	if body.is_in_group("can_be_deflected"):
		body.deflect("right")
