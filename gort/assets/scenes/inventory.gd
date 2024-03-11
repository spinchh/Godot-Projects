extends Control

var sprintShoes = preload("res://assets/art/items/sprintShoes.png")
var doubleJumpBoots = preload("res://assets/art/items/doubleJumpBoots.png")
var pickAxe = preload("res://assets/art/items/pickaxe.png")
var fireBall = preload("res://assets/art/items/fireball_pickup.png")


func _ready():
	pass

func itemCollected(itemType):
	if itemType == 'sprint':
		$Popup/TextureRect.texture = sprintShoes
		$Popup/title.text = "Running Shoes"
		$Popup/description.text = "Press and Hold SHIFT to run faster"
	elif itemType == 'doubleJump':
		$Popup/TextureRect.texture = doubleJumpBoots
		$Popup/title.text = "Double Jump Boots"
		$Popup/description.text = "Press JUMP in the air to jump again"
	elif itemType == 'pickAxe':
		$Popup/TextureRect.texture = pickAxe
		$Popup/title.text = "Pickaxe"
		$Popup/description.text = "Walk up to large rocks to destroy them"
	elif itemType == 'fireBall':
		$Popup/TextureRect.texture = fireBall
		$Popup/title.text = "Fireball"
		$Popup/description.text = "Press Q to launch a projectile"
		
	$Popup.visible = true
	fadeOut()

func fadeOut():
	yield(get_tree().create_timer(4), 'timeout')
	$Tween.interpolate_property($Popup, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	object.visible = false
	object.modulate = (Color(1,1,1,1))

func _on_sprintShoes_collected(itemType):
	itemCollected(itemType)

