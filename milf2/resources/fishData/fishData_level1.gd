extends Resource

class_name FishData

#Data dictionary containing values for all the fish in the first biome.
var fishTable = [0,1]

# Called when the node enters the scene tree for the first time.
func _ready():
	#load values into fishTable
	var fish0 = {
		'name' = "Minnow",
		'value' = 1,
		'swimSpeed' = 10,
		'spritePath' = "res://art/newFish/minnow/minnow1.png"
	}
	fishTable.append(fish0)
	
	var fish1 = {
		'name' = "Trout",
		'value' = 5,
		'swimSpeed' = 20,
		'spritePath' = "res://art/fish/trout1.png"
	}
	fishTable.append(fish1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func testFunction():
	print("test function gud")
