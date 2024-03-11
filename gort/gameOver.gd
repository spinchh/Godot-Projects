extends CanvasLayer


func _ready():
	pass
	

func _on_Player_died():
	$Popup.visible = true


func _on_Button_pressed():
	get_tree().change_scene("res://assets/scenes/Level 1.tscn")
