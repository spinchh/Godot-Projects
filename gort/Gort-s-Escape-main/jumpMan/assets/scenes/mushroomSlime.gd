extends Area2D

signal mushroomPurchase

var heartsBought = 0
var mushroomsRequired = 2

var mushroomCount = PlayerVariables.dataDictionary['mushrooms'].size()

const HEARTPICKUP = preload("res://assets/scenes/heartPickup.tscn")

func _on_interactionArea_body_entered(body):
	mushroomCount = PlayerVariables.dataDictionary['mushrooms'].size()
	if mushroomCount >= mushroomsRequired:
		heartsBought = heartsBought + 1
		print(mushroomCount)
		emit_signal("mushroomPurchase")
		spawnHealthPickup()
		
	else:
		print(mushroomCount)

func spawnHealthPickup():
	if heartsBought == 1:
		get_node("heartPickup").showSprite()
		mushroomsRequired = 4
	elif heartsBought == 2:
		$heartPickup2.showSprite()
		mushroomsRequired = 6
	elif heartsBought == 3:
		$heartPickup3.showSprite()
	
	

