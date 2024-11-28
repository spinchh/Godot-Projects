extends StaticBody2D


func _ready():
	pass


func _on_interactionArea_body_entered(body):
	if body.get("hasPickaxe"):
		$AnimatedSprite2D.visible = false
		$AudioStreamPlayer.play()
		set_collision_layer_value(1, false)
		set_collision_mask_value(0, false)
		$interactionArea.set_collision_mask_value(0, false)
