extends Node2D

export var rotation_speed = PI + 3
var blade = preload("res://Objects/Hazards and Enemies/SpinnyBlade.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	$Pivot.rotation += rotation_speed * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BladeTimer_timeout():
	print("Blade spawning")
	var blade_inst = blade.instance()
	blade_inst.start($Pivot/Sprite/BladeSpawn.global_position, $Pivot.rotation)
	get_parent().add_child(blade_inst)
