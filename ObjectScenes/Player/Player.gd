extends KinematicBody2D

var speed = 150
var move_dir = Vector2(0, 0)
var anim_dir = "L"
var index
var p_state
enum state {DEFAULT, NO_MOVEMENT}

func init(index):
	self.index = index
	self.set_name("Player" + str(index))
	self.p_state = state.DEFAULT

func _physics_process(delta):
	if p_state == state.DEFAULT:
		MovementLoop()
	pass


func _process(delta):
	if p_state == state.DEFAULT:
		MoveAnimationLoop()
	

func MovementLoop():
	move_dir.x = int(Input.is_action_pressed("move_right" + str(index))) - int(Input.is_action_pressed("move_left" + str(index)))
	move_dir.y = (int(Input.is_action_pressed("move_down" + str(index))) - int(Input.is_action_pressed("move_up" + str(index)))) / float(2)
	var motion = move_dir.normalized() * speed
	move_and_slide(motion)

func MoveAnimationLoop():
	var animation
	var anim_mode = "Idle"
	
	if move_dir.x > 0:
		anim_dir = "R"
	elif move_dir.x < 0:
		anim_dir = "L"
	
	if move_dir != Vector2(0, 0):
		anim_mode = "Walk"
	
	animation = anim_mode + "_" + anim_dir
	get_node("AnimationPlayer").play(animation)
