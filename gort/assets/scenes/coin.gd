extends Area2D

signal coinCollected

func _on_coin_body_entered(body):
	$AnimationPlayer.play("bounce")
	emit_signal("coinCollected")
	set_collision_mask_bit(0, false)
	$soundCollect.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
