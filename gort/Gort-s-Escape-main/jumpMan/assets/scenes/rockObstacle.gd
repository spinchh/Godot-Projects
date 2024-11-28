extends StaticBody2D


func _ready():
	pass


func _on_interactionArea_body_entered(body):
	if body.get("hasPickaxe"):
		$AnimatedSprite.visible = false
		$AudioStreamPlayer.play()
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(0, false)
		$interactionArea.set_collision_mask_bit(0, false)
