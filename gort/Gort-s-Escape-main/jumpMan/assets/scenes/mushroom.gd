extends StaticBody2D

signal mushroomCollected

export var mushroomNumber = 0

func _ready():
	$AnimationPlayer.play("idle")


func _on_Area2D_body_entered(body):
	PlayerVariables.dataDictionary['mushrooms'].append(mushroomNumber)
	print(PlayerVariables.dataDictionary['mushrooms'])
	emit_signal("mushroomCollected")
	$AnimationPlayer.play("collected")
	$Area2D.set_collision_mask_bit(0, false)
	$soundCollected.play()

func hideShroom():
	$Area2D.set_collision_mask_bit(0, false)
	$Sprite.visible = false
