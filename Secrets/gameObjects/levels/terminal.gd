extends StaticBody2D

signal playerNearDoor(status)

@export var inputCode: Array[int]
@export var doorCode: bool

@onready var inputRects = preload("res://gameObjects/UI/inputRect.tscn")

var arrowUpTexture = preload("res://art/Custom/UI/arrowUp.png")
var arrowDownTexture = preload("res://art/Custom/UI/arrowDown.png")
var arrowLeftTexture = preload("res://art/Custom/UI/arrowLeft.png")
var arrowRightTexture = preload("res://art/Custom/UI/arrowRight.png")

var bodyEntered = false

func _ready():
	if inputCode:
		logInput(inputCode)
	if doorCode:
		$AnimatedSprite2D.self_modulate = Color(1,1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bodyEntered:
		$interactionArea/TextureRect.visible = true
		$inputHandler.visible = false
		if Input.is_action_pressed("left_trigger"):
			$interactionArea/TextureRect.visible = false
			$inputHandler.visible = true
		if Input.is_action_just_pressed("left_trigger") and doorCode:
				get_parent().ghostCode()
	else:
		$interactionArea/TextureRect.visible = false
		$inputHandler.visible = false

#adds D-pad UI elements to input screen
func logInput(inputCode):
	for n in inputCode:
		var i = inputRects.instantiate()
		match n:
			1:
				i.get_child(0).texture = arrowUpTexture
			2:
				i.get_child(0).texture = arrowRightTexture
			3:
				i.get_child(0).texture = arrowDownTexture
			4:
				i.get_child(0).texture = arrowLeftTexture
		$inputHandler/HBoxContainer.add_child(i)


func _on_interaction_area_body_entered(body):
	bodyEntered = true
	emit_signal('playerNearDoor', bodyEntered)


func _on_interaction_area_body_exited(body):
	bodyEntered = false
	emit_signal('playerNearDoor', bodyEntered)
