extends Node2D


onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer
const dash_delay = 2
var can_dash = true
var ghost_scene = preload("res://Objects/Player/PlayerDash/DashGhost.tscn")
var sprite
var pos

# Called when the node enters the scene tree for the first time.
func start_dash(sprite, pos, duration):
	self.sprite = sprite
	self.pos = pos
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	
func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	can_dash = false
	yield(get_tree().create_timer(dash_delay), 'timeout')
	can_dash = true

func _on_DurationTimer_timeout():
	end_dash()
	

func instance_ghost():
	var ghost: Sprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = pos.global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h


func _on_GhostTimer_timeout():
	instance_ghost()
