extends CanvasLayer


func _ready():
	pass


func _on_launchPad_win():
	yield(get_tree().create_timer(2), "timeout")
	$Popup.visible = true


func _on_Button_pressed():
	get_tree().change_scene("res://assets/scenes/startScreen.tscn")
