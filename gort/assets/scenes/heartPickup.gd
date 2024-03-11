extends Area2D

export var pickupNumber = 0

func _ready():
	$Sprite.visible = false
	set_collision_mask_bit(0, false)


func _on_heartPickup_body_entered(body):
	body.addHealth()
	$Sprite.visible = false
	set_collision_mask_bit(0, false)
