extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var damage = 1

func start(x_speed, y_speed, angle, pos):
	rotation = angle
	position = pos
	rotation_degrees = angle
	velocity = Vector2(x_speed, y_speed)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
