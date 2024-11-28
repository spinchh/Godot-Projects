extends Area2D

export var itemType = 'null'
signal collected

func _ready():
	if itemType == 'doubleJump':
		$AnimatedSprite.play("doubleJump")
	elif itemType == 'sprint':
		$AnimatedSprite.play("sprint")
	elif itemType == 'fireBall':
		$AnimatedSprite.play("fireBall")
		hideItem()
	elif itemType == 'pickAxe':
		$AnimatedSprite.play("pickAxe")
		hideItem()
	
	$AnimationPlayer.play("idle")

func hideItem():
	$AnimatedSprite.visible = false
	set_collision_mask_bit(0, false)

func showItem():
	$AnimatedSprite.visible = true
	set_collision_mask_bit(0, true)

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
