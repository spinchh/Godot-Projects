extends Control

func _ready():
	if !PlayerData.speedrunMode:
		self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel/Label.text = formatTime(PlayerData.elapsedTime)

func formatTime(elapsed_time: float) -> String:
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	var centiseconds = int(fmod(elapsed_time, 1.0) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, centiseconds]
