extends Area2D

@export var targetLevel : String
@export var blackOutScreen : Node


func _on_body_entered(body):
	blackOutScreen.fadeScreen(targetLevel)
