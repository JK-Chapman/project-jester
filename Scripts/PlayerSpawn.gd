extends Position2D

var player_dashpunch = preload("res://Objects/Player_dashpunch/Player.tscn")
var player_tapjump = preload("res://Objects/Player_tapjump/Player_tapjump.tscn")
var camera
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_parent().get_node("ZoomCam")
	var current_player_type = GameManager.current_player_type
	for i in GameManager.player_dicts.values():
		if (i[1] == 0):
			var player_inst
			if current_player_type == "dashpunch":
				player_inst = player_dashpunch.instance()
			if current_player_type == "tapjump":
				player_inst = player_tapjump.instance()
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
