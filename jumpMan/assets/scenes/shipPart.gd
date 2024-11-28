extends Area2D

@export var shipPartNumber = 0

func _ready():
	
	$AnimatedSprite2D/AnimationPlayer.play('default')
	
	if shipPartNumber == 0:
		$AnimatedSprite2D.play("0")
	elif shipPartNumber == 1:
		$AnimatedSprite2D.play("1")
	elif shipPartNumber == 2:
		$AnimatedSprite2D.play("2")
	elif shipPartNumber == 3:
		$AnimatedSprite2D.play("3")
	elif shipPartNumber == 4:
		$AnimatedSprite2D.play("4")
	elif shipPartNumber == 5:
		$AnimatedSprite2D.play("5")
	elif shipPartNumber == 6:
		$AnimatedSprite2D.play("6")

func _on_shipPart_body_entered(body):
	$AnimatedSprite2D.visible = false
	set_collision_mask_value(0, false)
	$soundCollected.play()
	PlayerVariables.dataDictionary['shipParts'].append(shipPartNumber)
	print(PlayerVariables.dataDictionary['shipParts'])
