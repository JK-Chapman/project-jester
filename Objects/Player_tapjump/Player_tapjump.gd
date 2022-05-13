extends KinematicBody2D

const JUMP = 350
const GRAVITY = 30
const MAX_GRAV = 200

onready var stun_timer = $StunTimer
onready var immune_timer = $ImmuneTimer
onready var player_box = $player_box
onready var minigame_manager = get_parent().get_node("MinigameManager")


var speed = 125
var move_dir = Vector2(0, 0)
var motion = Vector2(0, 0)
var life = 1
var on_floor = false
var UP = Vector2(0, -1)
var bounce = false
var hit_sound_fx = load("res://SoundEffects/ripoff_smash.wav")
var ko_sound_fx = load("res://SoundEffects/melee_bat.wav")
var is_dead = false
var is_stopped = false
var death_start_time = OS.get_ticks_msec()
var kill_start_time = OS.get_ticks_msec()


var anim_dir = "L"
var anim_mode = "Idle"

var index
var p_state
enum state {DEFAULT, MINIGAME_CONTROL, DEAD}
var checked_stick = false
var assigned_spawn

onready var sprite = $Sprite

func init(index):
	self.index = index
	self.set_name("Player" + str(index))
	get_node("Sprite").self_modulate = GameManager.player_dicts[index][2]

func _physics_process(delta):
	motion.y += GRAVITY
	
	if !is_stunned() and !is_dead:
		if !minigame_manager.players_stopped:
			if Input.is_action_pressed("move_right" + str(index)):
				motion.x = speed
			if Input.is_action_pressed("move_left" + str(index)):
				motion.x = -speed
			if Input.is_action_just_pressed("jump_" + str(index)):
				motion.y = -JUMP
		
		move_dir.x = int(Input.is_action_pressed("move_right" + str(index))) - int(Input.is_action_pressed("move_left" + str(index)))
		move_dir.y = (int(Input.is_action_pressed("move_down" + str(index))) - int(Input.is_action_pressed("move_up" + str(index)))) / float(2)
	
	if motion.y < 0:
		self.set_collision_layer_bit(1, false)
	else:
		self.set_collision_layer_bit(1, true)
		
	
	var collision = move_and_slide(motion, Vector2.UP)
	
	for i in get_slide_count():
		var collider = get_slide_collision(i).collider
		if collider.is_in_group("player"):
			if OS.get_ticks_msec() - kill_start_time < 100:
				return
			kill_start_time = OS.get_ticks_msec()
			motion.y = -300
			collider.get_owner().stun()
	
	motion.x = lerp(motion.x,0,0.2)
	
	
func stun():
	if !is_stunned():
		print("Player" + str(index) +  " got stunned!")
		GameManager.play_sound(hit_sound_fx)
		stun_timer.start()
		immune_timer.start()
		return
	elif is_stunned() and !is_immune() and !is_dead:
		kill_player()

func _unhandled_input(event):
	pass

func _process(delta):
	AnimationLoop()

func kill_player():
	life = 0
	if OS.get_ticks_msec() - death_start_time < 100:
		return
	death_start_time = OS.get_ticks_msec()
	is_dead = true
	var camera = get_parent().get_node("ZoomCam")
	camera.remove_target(self)
	GameManager.play_sound(ko_sound_fx)
	$player_bounce/bounce_shape.disabled = true
	minigame_manager.alert_player_out_ffa(index)

func revive():
	life = 1
	is_dead = false
	$player_bounce/bounce_shape.disabled = false

func AnimationLoop():
	var animation
	anim_mode = "Fall"
	
	match move_dir:
		Vector2(-1, 0):
			anim_dir = "L"
		Vector2(1, 0):
			anim_dir = "R"
	
	animation = anim_mode + "_" + anim_dir
	
	get_node("AnimationPlayer").play(animation)

func is_stunned():
	return !stun_timer.is_stopped()
	
func is_immune():
	return !immune_timer.is_stopped()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hazard") and !is_dead:
		life -= 1
		if life <= 0:
			kill_player()
