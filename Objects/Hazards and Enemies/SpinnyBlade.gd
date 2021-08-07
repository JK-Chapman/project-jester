extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 1
var speed = 10
var velocity = Vector2()
var hit_sound_fx = load("res://SoundEffects/flesh_hit.mp3")


func start(pos, dir):
	rotation = dir
	position = pos
	speed = rand_range(30, 70)
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		
func deflect(dir):
	match dir:
		"left":
			speed += 10
			velocity = Vector2(speed, 0).rotated(PI)
		"right":
			speed += 10
			velocity = Vector2(speed, 0).rotated(0)
			
func destroy():
	GameManager.play_sound(hit_sound_fx)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
