extends Resource

class_name FishData

#Data dictionary containing values for all the fish in the first biome.

var fish0 = {
	'name' = "Minnow",
	'value' = 1,
	'swimSpeed' = 10,
	'spritePath' = "res://art/newFish/minnow/minnow1.png"
}

var fish1 = {
		'name' = "Trout",
		'value' = 5,
		'swimSpeed' = 20,
		'spritePath' = "res://art/fish/trout1.png"
	}

var fish2 = {
		'name' = "Trout",
		'value' = 5,
		'swimSpeed' = 20,
		'spritePath' = "res://art/fish/duck.png"
	}
	
var fish3 = {
		'name' = "gator",
		'value' = 5,
		'swimSpeed' = 20,
		'spritePath' = "res://art/fish/alligator.png"
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
