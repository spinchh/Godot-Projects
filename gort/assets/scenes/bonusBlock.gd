extends StaticBody2D

signal coinCollected
const COIN = preload("res://assets/scenes/coin.tscn")
func _on_bottomChecker_body_entered(body):
	
	var f = COIN.instance()
		
	get_parent().add_child(f)

	f.position.y = position.y - 40
	f.position.x = position.x
	
	f._on_coin_body_entered(body)
	emit_signal("coinCollected")
	
	$AnimationPlayer.play("hit")
	$blockSprite.play("used")
	$bottomChecker.set_collision_mask_bit(0, false)
	
