extends Node

onready var playerNode = get_node("Player")

var hasSprint = false
var hasDoubleJump = false
var hasPickaxe = false
var hasFireball = false

var defaultValues = {
	"maxHealth" : 6,
	"posx" : 256,
	"posy" : 430,
	
	"hasSprint" : false,
	"hasDoubleJump" : false,
	"hasPickaxe" : false,
	"hasFireball" : false,
	
	"coins" : 0,
	"mushrooms" : [],
	"shipParts" : [],
	"keyArray" : [],
	
	"lavaSlime" : false,
	"kingSlime" : false
}


var dataDictionary = {
	"maxHealth" : 6,
	"posx" : 256,
	"posy" : 430,
	
	"hasSprint" : false,
	"hasDoubleJump" : false,
	"hasPickaxe" : false,
	"hasFireball" : false,
	
	"coins" : 0,
	"mushrooms" : [],
	"shipParts" : [],
	"keyArray" : [],
	
	"lavaSlime" : false,
	"kingSlime" : false
}
var bosses = {
	"lavaSlime" : false,
	"kingSlime" : false
}

func _ready():
	pass
	
func saveData(savedData):
	dataDictionary = savedData
	print(dataDictionary)

