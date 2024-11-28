extends Node2D

onready var kingSlime = get_node("cameraDemon1/slimeKingCamera")
onready var lavaSlime = get_node("cameraDemon2/lavaSlimeCamera")
onready var player = get_node("Player/Camera2D")

func _ready():
	pass

func transition():
	
	$Tween.interpolate_property()

#lavaSlime
func _on_AI_trigger1_body_entered(body):
	pass # Replace with function body.
