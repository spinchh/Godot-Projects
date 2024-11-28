extends Control

@onready var blackoutScreen = $blackOutScreen

var tutorial = "res://gameObjects/levels/level_0.tscn"
var mainLevel = "res://gameObjects/levels/level_2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	$music.play()
	$buttons/Button.grab_focus()
	if PlayerData.playerData.hasBeatenGame == false:
		$buttons/Button3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	blackoutScreen.fadeScreen(tutorial)
	PlayerData.speedrunMode = false


func _on_button_3_pressed():
	blackoutScreen.fadeScreen(mainLevel)
	PlayerData.speedrunMode = true
	PlayerData.restartTimer()
	PlayerData.startTimer()
