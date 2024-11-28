extends Area2D

@export var pickupNumber = 0

func _ready():
	$Sprite2D.visible = false
	set_collision_mask_value(0, false)


func _on_heartPickup_body_entered(body):
	body.addHealth()
	$Sprite2D.visible = false
	set_collision_mask_value(0, false)
