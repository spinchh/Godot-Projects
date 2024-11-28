extends AnimatedSprite2D



func _on_boss_died():
	play("default")
	$StaticBody2D/CollisionShape2D.disabled = true
