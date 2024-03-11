extends StaticBody2D

export var lockColor = "Blue"

func _ready():
	if lockColor == "Yellow":
		$Sprite.play("yellow")
	elif lockColor == "Blue":
		$Sprite.play("blue")
	elif lockColor == "Red":
		$Sprite.play("red")
	elif lockColor == "Green":
		$Sprite.play("green")
	
	$AnimationPlayer.play("idle")

func unlock():
	$AnimationPlayer.play("unlock")
	$soundUnlock.play()
	
	yield(get_tree().create_timer(.5), "timeout")
	
	set_collision_layer_bit(6, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(4, false)
	set_collision_mask_bit(5, false)
	
	
