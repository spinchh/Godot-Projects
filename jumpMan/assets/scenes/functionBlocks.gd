extends StaticBody2D

@export var lockColor = "Blue"

func _ready():
	if lockColor == "Yellow":
		$Sprite2D.play("yellow")
	elif lockColor == "Blue":
		$Sprite2D.play("blue")
	elif lockColor == "Red":
		$Sprite2D.play("red")
	elif lockColor == "Green":
		$Sprite2D.play("green")
	
	$AnimationPlayer.play("idle")

func unlock():
	$AnimationPlayer.play("unlock")
	$soundUnlock.play()
	
	await get_tree().create_timer(.5).timeout
	
	set_collision_layer_value(6, false)
	set_collision_mask_value(0, false)
	set_collision_mask_value(4, false)
	set_collision_mask_value(5, false)
	
	
