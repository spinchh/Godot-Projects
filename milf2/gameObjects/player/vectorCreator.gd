extends Area2D

signal vectorCreated

#limit to distance a vector can be drawn
@export var hardLimit = 300

#state variable, determines if screen is beinbg touched down on
var touchDown = false

#position variables for drawing final vector
var positionStart = Vector2.ZERO
var positionEnd = Vector2.ZERO

#final vector
var vector = Vector2.ZERO

#connect input_event signal to self
func _ready():
	self.input_event.connect(self._on_input_event)

func _input(event):
	#pass if screen is not being touched down on
	if not touchDown:
		return
	
	#send vector when screen is released, reset all values
	if event.is_action_released("ui_touch"):
		touchDown = false
		emit_signal("vectorCreated", vector)
		reset()
	
	#update final vector when dragging along the screen
	if event is InputEventMouseMotion:
		positionEnd = event.global_position
		vector = -(positionEnd - positionStart).limit_length(hardLimit)
		queue_redraw()

#actions to take when screen is pressed down on
func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_touch"):
		touchDown = true
		positionStart = event.global_position

func reset():
	positionStart = Vector2.ZERO
	positionEnd = Vector2.ZERO
	vector = Vector2.ZERO
	queue_redraw()

#draws the red line as a fraction of the final vector
func _draw():	
	var parentGlobalPosition = get_parent().global_position
	var fraction = .2
	var startPoint = parentGlobalPosition - global_position + vector * fraction
	draw_line(startPoint, parentGlobalPosition - global_position + vector, Color.RED, 8, true)
