extends Area2D

var partCount = 0

signal win

func _ready():
	$ship.visible = false
	$Label.visible = false


func _on_launchPad_body_entered(body):
	
	partCount = PlayerVariables.dataDictionary['shipParts'].size()
	if partCount >= 6:
		$ship.visible = true
		$ship/AnimationPlayer.play("launch")
		emit_signal("win")
	else:
		showLabel()

func showLabel():
	$Label.set_text(str(partCount, "/6 Ship Parts Found"))
	$Label.visible = true


func _on_launchPad_body_exited(body):
	$Label.visible = false
