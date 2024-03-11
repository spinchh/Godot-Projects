extends Node2D

onready var keyArray = PlayerVariables.dataDictionary['keyArray']
onready var mushroomArray = PlayerVariables.dataDictionary['mushrooms']
onready var shipPartsArray = PlayerVariables.dataDictionary['shipParts']

func _ready():
	#check which keys are collected and despawn them.
	for i in get_node('keys').get_child_count():
		var key = get_node("keys").get_child(i)
		if keyArray.has(key.keyColor):
			key.queue_free()
	
	#hide collected mushrooms
	for i in get_node("mushrooms").get_child_count():
		var shroom = get_node('mushrooms').get_child(i)
		if mushroomArray.has(shroom.mushroomNumber):
			shroom.queue_free()
	
	for i in get_node("ship parts").get_child_count():
		var ship = get_node("ship parts").get_child(i)
		if shipPartsArray.has(ship.shipPartNumber):
			ship.queue_free()
	if PlayerVariables.dataDictionary['hasDoubleJump'] == true:
		get_node("items/doubleJumpShoes").queue_free()
	
	if PlayerVariables.dataDictionary['hasSprint'] == true:
		get_node("items/sprintShoes").queue_free()
		
	if PlayerVariables.dataDictionary['hasPickaxe'] == true:
		get_node("items/pickAxe").queue_free()
	
	if PlayerVariables.dataDictionary['hasFireball'] == true:
		get_node("items/fireBallPickup").queue_free()

