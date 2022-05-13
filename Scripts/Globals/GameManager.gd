extends Node


# player_dicts will manage players that are currently instanced and are in use.
# Keys are player controller index, values will be an array required to instance the player.
#
# format: player_dicts = {0: [0, 0]} -- Key is index. Array format: [index, instantiated_in_minigame, modulate]
# key references index.
# first value in dict references index as well, second value is whether player is instantiated in current level.
var player_dicts = {}
var level_dict = {}


var current_game = ""
var current_player_type = ""
var winning_color = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://JSON/LevelList.json", file.READ)
	var text = file.get_as_text()
	level_dict = parse_json(text)
	file.close()
	
func play_sound(sound):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.connect("finished", player, "queue_free")
	add_child(player)
	player.play()

func reset_game():
	GameManager.player_dicts = {}
	GameManager.current_game = ""
	GameManager.current_player_type = ""

func reset_player_instanced():
	for i in player_dicts:
		player_dicts[i][1] = 0

func load_random_level(type):
	reset_player_instanced()
	randomize()
	var level = level_dict[type]
	print(level)
	level = level[int(rand_range(0, level.size()))]
	print(level)
	current_game = level[0]
	current_player_type = level[1]
	SceneSwitcher.change_scene("LevelScenes/" + current_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
