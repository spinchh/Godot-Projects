extends Area2D

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate = Color(1,1,1,0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1,1,1,1.0), .4)
	await tween.finished
	tween.kill()


func _on_body_exited(body):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1,1,1,0.0), .4)
	await tween.finished
	tween.kill()
