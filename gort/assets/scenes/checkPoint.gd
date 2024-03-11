extends Area2D

signal saveGame

func _ready():
	$flag/AnimationPlayer.play("default")


func _on_checkPoint_body_entered(body):
	$flag/AnimationPlayer.play("raise")
	emit_signal('saveGame')
	$checkpointSound.play()
