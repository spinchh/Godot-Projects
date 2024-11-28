extends Control

@onready var blackOutScreen = $blackOutScreen

func _ready():
	PlayerData.stopTimer()
	$Button.grab_focus()
	if PlayerData.speedrunMode:
		$speedrunLabel.visible = true
		$speedrunLabel/Label4.text = formatTime(PlayerData.elapsedTime)

func _on_button_pressed():
	PlayerData.playerData.hasBeatenGame = true
	blackOutScreen.fadeScreen("res://gameObjects/levels/main_menu.tscn")

func formatTime(elapsed_time: float) -> String:
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	var centiseconds = int(fmod(elapsed_time, 1.0) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, centiseconds]
