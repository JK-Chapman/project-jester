extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var rounds_to_win = 0
var players_score_dict = {}
var players_alive_dict = {}
var players_stopped = true
var match_point = false
var game_over = false
onready var spawn_points = get_parent().get_node("SpawnPoints")
onready var GameMusic = $GameMusic
onready var MPMusic = $MPMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GameManager.player_dicts:
		players_score_dict[i] = 0
		players_alive_dict[i] = 1
	$RoundTimer.start()

func add_point(index):
	players_score_dict[index] += 1
	
	if players_score_dict[index] == (rounds_to_win - 1):
		match_point = true
	
	if players_score_dict[index] == rounds_to_win:
		GameManager.player_dicts[index][3] += 1
		
		if GameManager.player_dicts[index][3] == 3:
			print("Player" + str(index) + " won the game!")
			SceneSwitcher.change_scene("LevelScenes/WinScene.tscn")
			GameManager.winning_color = GameManager.player_dicts[index][2]
		else:
			$WinTimer/WinLabel.text = "Player" + str(index) + " won the minigame!"
			$WinTimer.start()
			game_over = true
	else:
		for i in players_alive_dict:
			players_alive_dict[i] = 1
		players_stopped = true
		GameMusic.stop()
		MPMusic.stop()
		revive_players()
		$RoundTimer/TimerLabel.visible = true
		$RoundTimer.start()

# For elimination style FFA games.
func alert_player_out_ffa(index):
	print("Player" + str(index) + " was eliminated!")
	players_alive_dict[index] = 0
	
	# Check for player win after elimination.
	var winning_index = null
	var win_cnt = 0
	for i in players_alive_dict:
		if players_alive_dict[i] == 1:
			winning_index = i
			win_cnt += 1

	if win_cnt == 1:
		print("Player" + str(winning_index) + " scored a point!")
		add_point(winning_index)

func revive_players():
	for sp in spawn_points.get_children():
		sp.revive_player()

func _process(delta):
	$RoundTimer/TimerLabel.text = "Game starts in: " + str($RoundTimer.time_left)
	if game_over:
		$WinTimer/TimerLabel.text = "Next game starts in: " + str($WinTimer.time_left)

func _on_RoundTimer_timeout():
	players_stopped = false
	$RoundTimer/TimerLabel.visible = false
	
	if !match_point:
		GameMusic.play()
	else:
		MPMusic.play()


func _on_WinTimer_timeout():
	GameManager.load_random_level("AllLevels")
