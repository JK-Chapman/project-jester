extends KinematicBody2D

var speed = 150
var move_dir = Vector2(0, 0)

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
		if move_dir.x > 0:
			anim_dir = "R"
		elif move_dir.x < 0:
			anim_dir = "L"
			
		if move_dir != Vector2(0, 0):
			anim_mode = "Run"
	
	animation = anim_mode + "_" + anim_dir
	get_node("AnimationPlayer").play(animation)
	
func Attack():
	yield(get_tree().create_timer(0.48), "timeout")
	punching = false
	anim_mode = "Idle"
