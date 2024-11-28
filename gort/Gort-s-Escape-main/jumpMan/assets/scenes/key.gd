extends Node2D

export var keyColor = "Blue"
signal keyCollected(color)

func _ready():
	if keyColor == "Yellow":
		$Sprite.play("yellow")
	elif keyColor == "Blue":
		$Sprite.play("blue")
	elif keyColor == "Red":
		$Sprite.play("red")
		if PlayerVariables.bosses['lavaSlime'] == false:
			hideKey()
	elif keyColor == "Green":
		$Sprite.play("green")

func hideKey():
	$Area2D.set_collision_mask_bit(0, false)
	$Sprite.visible = false

func _on_Area2D_body_entered(body):
	emit_signal("keyCollected", keyColor)
	hideKey()
	$soundCollected.play()
	PlayerVariables.dataDictionary['keyArray'].append(keyColor)

func _on_fireBallPickup_body_entered(body):
	if keyColor == "Red":
		$Sprite.visible = true
		$Area2D.set_collision_mask_bit(0, true)
