extends Area2D

@export var itemType = 'null'
signal collected

func _ready():
	if itemType == 'doubleJump':
		$AnimatedSprite2D.play("doubleJump")
	elif itemType == 'sprint':
		$AnimatedSprite2D.play("sprint")
	elif itemType == 'fireBall':
		$AnimatedSprite2D.play("fireBall")
		hideItem()
	elif itemType == 'pickAxe':
		$AnimatedSprite2D.play("pickAxe")
		hideItem()
	
	$AnimationPlayer.play("idle")

func hideItem():
	$AnimatedSprite2D.visible = false
	set_collision_mask_value(0, false)

func showItem():
	$AnimatedSprite2D.visible = true
	set_collision_mask_value(0, true)

func _on_sprintShoes_body_entered(body):
	emit_signal("collected", itemType)
	body.itemCollected(itemType)
	$soundCollected.play()
	hideItem()

func _on_lavaSlime_spawnItemDrop():
	if itemType == 'fireBall':
		showItem()

func _on_pickaxeMan_purchasedItem():
	if itemType == 'pickAxe':
		showItem()
