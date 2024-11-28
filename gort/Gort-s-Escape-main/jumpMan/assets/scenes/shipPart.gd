extends Area2D

export var shipPartNumber = 0

func _ready():
	
	$AnimatedSprite/AnimationPlayer.play('default')
	
	if shipPartNumber == 0:
		$AnimatedSprite.play("0")
	elif shipPartNumber == 1:
		$AnimatedSprite.play("1")
	elif shipPartNumber == 2:
		$AnimatedSprite.play("2")
	elif shipPartNumber == 3:
		$AnimatedSprite.play("3")
	elif shipPartNumber == 4:
		$AnimatedSprite.play("4")
	elif shipPartNumber == 5:
		$AnimatedSprite.play("5")
	elif shipPartNumber == 6:
		$AnimatedSprite.play("6")

func _on_shipPart_body_entered(body):
	$AnimatedSprite.visible = false
	set_collision_mask_bit(0, false)
	$soundCollected.play()
	PlayerVariables.dataDictionary['shipParts'].append(shipPartNumber)
	print(PlayerVariables.dataDictionary['shipParts'])
