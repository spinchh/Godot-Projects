extends Enemy

const FLY = preload("res://gameObjects/enemies/fly/fly.tscn")

var flyCount = 0
var canSpawn = true

func _ready():
	health = 10

func _physics_process(delta):
	if flyCount <= 3 and canSpawn and player:
		spawnFly()

func spawnFly():
	var f = FLY.instantiate()
	canSpawn = false
	f.player = player
	f.scale *= .5
	f.connect("died", Callable(self, "on_childDied"))
	add_child(f)
	$SFX/spawnSound.play()
	flyCount += 1


func _on_timer_timeout():
	canSpawn = true

func on_childDied():
	flyCount -= 1
