extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 1
var speed = 150
var max_speed = 250
var velocity = Vector2()
var hit_sound_fx = load("res://SoundEffects/flesh_hit.mp3")


func start(pos, dir):
	rotation = dir
	position = pos
	speed = rand_range(100, 150)
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		
func deflect(dir):
	speed *= 1.2
	if speed > max_speed: speed = max_speed
	match dir:
		"left":
			velocity = Vector2(speed, 0).rotated(PI)
		"right":
			velocity = Vector2(speed, 0).rotated(0)
		"up":
			velocity = Vector2(speed, 0).rotated((3 * PI)/2)
		"down":
			velocity = Vector2(speed, 0).rotated(PI/2)
		"up_left":
			velocity = Vector2(speed, 0).rotated((5 * PI) / 4)
		"up_right":
			velocity = Vector2(speed, 0).rotated((7 * PI) / 4)
		"down_left":
			velocity = Vector2(speed, 0).rotated((3 * PI) / 4)
		"down_right":
			velocity = Vector2(speed, 0).rotated(PI/4)

func destroy():
	GameManager.play_sound(hit_sound_fx)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
