extends Node


# player_dicts will manage players that are currently instanced and are in use.
# Keys are player controller index, values will be an array required to instance the player.
# ex: player_dicts = {0: [0, 0]} -- Player 0 exists and will be instantiated with index 0.
var player_dicts = {}
var level_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://JSON/LevelList.json", file.READ)
	var text = file.get_as_text()
	level_dict = parse_json(text)
	file.close()

func load_random_level(type):
	randomize()
	var level = level_dict[type]
	print(level)
	level = level[int(rand_range(0, level.size()))]
	SceneSwitcher.change_scene("LevelScenes/" + level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
