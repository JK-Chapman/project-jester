extends KinematicBody2D

var speed = 200
var UP = Vector2(0, -1)
const JUMP = 500
const MAXFALLSPEED = 200
const GRAVITY = 30
var move_dir = Vector2(0, 0)
var life = 3
var on_floor = false

var anim_dir = "L"
var anim_mode = "Idle"

var index
var p_state
enum state {DEFAULT, MINIGAME_CONTROL, DEAD}
var checked_stick = false

onready var sprite = $Sprite

func init(index):
	self.index = index
	self.set_name("Player" + str(index))

func _physics_process(delta):
	move_dir.y += GRAVITY
	
	if Input.is_action_pressed("move_right" + str(index)):
		move_dir.x = speed
	if Input.is_action_pressed("move_left" + str(index)):
		move_dir.x = -speed
	if Input.is_action_just_pressed("jump_" + str(index)):
		move_dir.y = -JUMP
	
	move_and_slide(move_dir, Vector2.UP)
	
	move_dir.x = lerp(move_dir.x,0,0.2)
	
func _unhandled_input(event):
	pass

func _process(delta):
	AnimationLoop()

func AnimationLoop():
	var animation
	anim_mode = "Idle"
	
	match move_dir:
		Vector2(-1, 0):
			anim_dir = "L"
		Vector2(1, 0):
			anim_dir = "R"
		Vector2(0, 0.5):
			anim_dir = "D"
	
	animation = anim_mode + "_" + anim_dir
	
	get_node("AnimationPlayer").play(animation)
	
func take_damage(damage):
	life -= damage
	print("DEBUG: Player has taken damage and now has " + str(life) + " life.")

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Hazard"):
		take_damage(body.damage)
		body.destroy()
