extends Area2D

export var signText = "Bottom Text"

func _ready():
	$textBox.visible = false
	$textBox/Label.text = String(signText)

func _on_signPost_body_entered(body):
	$textBox.visible = true

func _on_signPost_body_exited(body):
	$textBox.visible = false
