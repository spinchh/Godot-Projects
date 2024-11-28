extends Node2D

@export var keyColor = "Blue"
signal keyCollected(color)

func _ready():
	if keyColor == "Yellow":
		$Sprite2D.play("yellow")
	elif keyColor == "Blue":
		$Sprite2D.play("blue")
	elif keyColor == "Red":
		$Sprite2D.play("red")
		if PlayerVariables.bosses['lavaSlime'] == false:
			hideKey()
	elif keyColor == "Green":
		$Sprite2D.play("green")

func hideKey():
	$Area2D.set_collision_mask_value(0, false)
	$Sprite2D.visible = false

func _on_Area2D_body_entered(body):
	emit_signal("keyCollected", keyColor)
	hideKey()
	$soundCollected.play()
	PlayerVariables.dataDictionary['keyArray'].append(keyColor)

func _on_fireBallPickup_body_entered(body):
	if keyColor == "Red":
		$Sprite2D.visible = true
		$Area2D.set_collision_mask_value(0, true)
