extends Position2D

var player = preload("res://Objects/Player/Player.tscn")
var camera
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_parent().get_node("ZoomCam")
	for i in GameManager.player_dicts.values():
		if (i[1] == 0):
			var player_inst = player.instance()
			player_inst.init(i[0])
			player_inst.position.x = self.position.x
			player_inst.position.y = self.position.y
			camera.add_target(player_inst)
			get_parent().call_deferred("add_child", player_inst)
			GameManager.player_dicts[i[0]] = [i[0], 1]
			return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
