extends Position2D

var player_dashpunch = preload("res://Objects/Player_dashpunch/Player.tscn")
var player_tapjump = preload("res://Objects/Player_tapjump/Player_tapjump.tscn")
onready var camera = get_parent().get_parent().get_node("ZoomCam")
onready var minigame_manager = get_parent().get_parent().get_node("MinigameManager")
var player_assigned
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var current_player_type = GameManager.current_player_type
	for i in GameManager.player_dicts:
		if (GameManager.player_dicts[i][1] == 0):
			if current_player_type == "dashpunch":
				player_assigned = player_dashpunch.instance()
			if current_player_type == "tapjump":
				player_assigned = player_tapjump.instance()
			player_assigned.init(i)
			player_assigned.position.x = self.position.x
			player_assigned.position.y = self.position.y
			camera.add_target(player_assigned)
			get_parent().get_parent().call_deferred("add_child", player_assigned)
			GameManager.player_dicts[i][1] = 1
			return

func revive_player():
	if player_assigned == null:
		return
	player_assigned.position.x = self.position.x
	player_assigned.position.y = self.position.y
	player_assigned.revive()
	camera.add_target(player_assigned)



func _process(delta):
	if (minigame_manager.players_stopped or minigame_manager.game_over) and player_assigned != null:
		$PointLabel.text = "P" + str(player_assigned.index + 1) + " Round Points: " + str(minigame_manager.players_score_dict[player_assigned.index]) + " \nMinigame Wins: " + str(GameManager.player_dicts[player_assigned.index][3])
	else:
		$PointLabel.text = ""


func _on_RoundTimer_timeout():
	if player_assigned == null:
		return
