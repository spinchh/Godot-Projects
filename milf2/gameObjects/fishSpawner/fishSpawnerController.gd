extends Node

enum BIOME {LAKE, OCEAN}
@export var levelName = "level1"

#maximum fish allowed on screen
@export var maxFish = 5
#fish currently spawned in
var fishSpawned = 0
#state variable determines if fish can be spawned
var canSpawnFish = true
#variable tied to the level currently being loaded in
var level = null

func _ready():
	#assign appropriate level data to level variable	
	level = load("res://resources/fishData/fishData_" + levelName + ".tres")
	get_tree().call_group("fishSpawners", "readyToLoad")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(fishSpawned)
	
	if fishSpawned < maxFish and canSpawnFish == true:
		get_tree().call_group("fishSpawners", "set_canSpawnFish")
	elif fishSpawned < maxFish and canSpawnFish != true:
		pass
	elif fishSpawned > maxFish and canSpawnFish == true:
		get_tree().call_group("fishSpawners", "set_cannotSpawnFish")
	else:
		pass
	#can spawn fish if fishSpawned is less than maxFish; otherwise, can't spawn fish
#	if fishSpawned < maxFish and canSpawnFish == true:
#		pass
#	elif fishSpawned < maxFish and canSpawnFish != true:
#		get_tree().call_group("fishSpawners", "set_canSpawnFish")
#	elif fishSpawned > maxFish and canSpawnFish == true:
#		get_tree().call_group("fishSpawners", "set_cannotSpawnFish")
#	else:
#		pass


func addFishToCount():
	fishSpawned += 1

func _on_player_update_fish_spawner(fishCaught):
	fishSpawned = fishSpawned - fishCaught
