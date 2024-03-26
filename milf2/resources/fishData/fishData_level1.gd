extends Resource

class_name FishData

#Data dictionary containing values for all the fish in the first biome.

var spriteSheet = "res://resources/fishData/level1FishSprites.tres"

var fish0 = {
	'name' = "Minnow",
	'value' = 1,
	'swimSpeed' = 10,
	}

var fish1 = {
		'name' = "Trout",
		'value' = 5,
		'swimSpeed' = 20,
	}

var fish2 = {
		'name' = "Bream",
		'value' = 3,
		'swimSpeed' = 20,
	}
	
var fish3 = {
		'name' = "gator",
		'value' = 5,
		'swimSpeed' = 20,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
