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
@export var maxFishID = 2


func _ready():
	controller = get_parent()
	initialPos = $CollisionShape2D.global_position
	maxSize = ($CollisionShape2D.shape.get_size())/2
	add_to_group("fishSpawners")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dataLoaded:
		pass
	if levelData == null:
		levelData = controller.level
	if canSpawnFish:
		spawnFish()
	elif !canSpawnFish:
		pass

#sets canSpawnFish based on signal received from FishSpawnController
func set_canSpawnFish():
	canSpawnFish = true
func set_cannotSpawnFish():
	canSpawnFish = false
func readyToLoad():
	dataLoaded = true

#spawns a random fish, somewhere within the bounds of the fishSpawner
func spawnFish():
	#type of fish to be spawned. Randomly determined, bound by min/max FishID
	var type = rng.randi_range(minFishID, maxFishID)
	
	var f = FISH.instantiate()	
	var fData = "fish" + str(type)
	
	f.fishName = levelData.get(fData).name
	f.value = levelData.get(fData).value
	f.swimSpeed = levelData.get(fData).swimSpeed
	f.spritePath = levelData.get(fData).spritePath
	
	fishPos.x = float(initialPos.x + rng.randf_range(maxSize.x, -maxSize.x))
	fishPos.y = float(initialPos.y + rng.randf_range(maxSize.y, -maxSize.y))
	f.position.x = fishPos.x
	f.position.y = fishPos.y
	
	controller.add_child(f)
	controller.addFishToCount()
