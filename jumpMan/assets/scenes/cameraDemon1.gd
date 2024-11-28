extends StaticBody2D


func _ready():
	pass


func _on_AI_trigger_body_entered(body):
	$slimeKingCamera.make_current()
