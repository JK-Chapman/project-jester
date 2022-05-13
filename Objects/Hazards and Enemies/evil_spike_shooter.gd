extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spike = preload("res://Objects/Hazards and Enemies/WallSpike.tscn")
export var x_spike_speed = 150
export var y_spike_speed = 0
export var spike_angle = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpikeTimer_timeout():
	var spike_inst = spike.instance()
	spike_inst.start(x_spike_speed, y_spike_speed, spike_angle, $spike_spawn.global_position)
	get_parent().call_deferred("add_child", spike_inst)
