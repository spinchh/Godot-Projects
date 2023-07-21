extends Area2D

const FISH = preload("res://gameObjects/fish/fish.tscn")

#stores level data for fish spawns
var levelData = null
#variable reference to controller node
var controller = null
#determines if the spawner should spawn fish
var canSpawnFish = true
#state variable preventing fish from spawning until data is loaded
var dataLoaded = false

#rng constructor
var rng = RandomNumberGenerator.new()

#boundaries of spawner area
var maxSize = Vector2.ZERO
#position of the fish within the spawner
var initialPos = Vector2.ZERO
var fishPos = Vector2.ZERO
#minimum/maximum fishID that can be spawned
@export var minFishID = 0
@export var maxFishID = 1
#type of fish to be spawned. Randomly determined, bound by min/max FishID
var type = rng.randi_range(minFishID, maxFishID)

func _ready():
	controller = get_parent()
	add_to_group("fishSpawners")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dataLoaded:
		pass
	if levelData == null:
		levelData = controller.level
	if canSpawnFish:
		spawnFish()
		#print(levelData)
		pass
	elif !canSpawnFish:
		print("cantSpawnFish")

#sets canSpawnFish based on signal received from FishSpawnController
func set_canSpawnFish():
	canSpawnFish = true
func set_cannotSpawnFish():
	canSpawnFish = false
func readyToLoad():
	dataLoaded = true

#spawns a random fish, somewhere within the bounds of the fishSpawner
func spawnFish():
	var f = FISH.instantiate()
	var fData = levelData.fishTable[type]
	
	#f.fishName = fData.name
	f.value = fData.value
	f.swimSpeed = fData.swimSpeed
	f.spritePath = fData.spritePath
	
	fishPos.x = float(initialPos.x + rng.randf_range(maxSize.x, -maxSize.x))
	fishPos.y = float(initialPos.y + rng.randf_range(maxSize.y, -maxSize.y))
	f.global_position.x = fishPos.x
	f.global_position.y = fishPos.y
	
	controller.add_child(f)
	controller.addFishToCount
