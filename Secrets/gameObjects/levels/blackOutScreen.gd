extends Control

@onready var colorRect = $ColorRect

func _ready():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(colorRect, "modulate", Color(0,0,0,0), .4)

func fadeScreen(targetLevel):
	var tween = get_tree().create_tween()
	tween.tween_property(colorRect, "modulate", Color.BLACK, .4)
	await tween.finished
	SceneChanger.changeScene(targetLevel)

func _on_load_zone_body_entered(body, targetLevel):
	fadeScreen(targetLevel)
