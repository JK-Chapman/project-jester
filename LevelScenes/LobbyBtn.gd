extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("Sprite").self_modulate = GameManager.winning_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LobbyBtn_pressed():
	GameManager.reset_game()
	SceneSwitcher.change_scene("LevelScenes/Lobby.tscn")


func _on_Timer_timeout():
	get_parent().get_node("WinPlayer").play()
	get_parent().get_node("Space").visible = true
	get_parent().get_node("Falcon").visible = true
	get_parent().get_node("Glasses").visible = true
	get_parent().get_node("LobbyBtn").visible = true


func _on_BlasterTimer_timeout():
	get_parent().get_node("Blaster").visible = true
