extends StaticBody2D

signal playerNearDoor(status)

@export var inputCode: Array[int]

@onready var inputRects = preload("res://gameObjects/UI/inputRect.tscn")

var arrowUpTexture = preload("res://art/Custom/UI/arrowUp.png")
var arrowDownTexture = preload("res://art/Custom/UI/arrowDown.png")
var arrowLeftTexture = preload("res://art/Custom/UI/arrowLeft.png")
var arrowRightTexture = preload("res://art/Custom/UI/arrowRight.png")

var ghostArrowUp = preload("res://art/Custom/UI/ghostArrow_up.png")
var ghostArrowDown = preload("res://art/Custom/UI/ghostArrow_down.png")
var ghostArrowLeft = preload("res://art/Custom/UI/ghostArrow_left.png")
var ghostArrowRight = preload("res://art/Custom/UI/ghostArrow_right.png")

var inputArr: Array[int]

var bodyEntered = false
var isUnlocked = false

func _ready():
	for digit in inputCode:
		var i = inputRects.instantiate()
		match digit:
			1:
				i.get_child(0).texture = ghostArrowUp
			2:
				i.get_child(0).texture = ghostArrowRight
			3:
				i.get_child(0).texture = ghostArrowDown
			4:
				i.get_child(0).texture = ghostArrowLeft
		$inputHandler/Panel/HBoxContainer2.add_child(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isUnlocked:
		return
	if bodyEntered:
		$interactionArea/TextureRect.visible = true
		$inputHandler.visible = false
		if Input.is_action_just_released("left_trigger"):
			checkInput(inputArr)
			clearInputLog()
		if Input.is_action_pressed("left_trigger"):
			$interactionArea/TextureRect.visible = false
			$inputHandler.visible = true
			#check for D-Pad inputs
			if Input.is_action_just_pressed("d_pad_up"):
				logInput(1)
			if Input.is_action_just_pressed("d_pad_right"):
				logInput(2)
			if Input.is_action_just_pressed("d_pad_down"):
				logInput(3)
			if Input.is_action_just_pressed("d_pad_left"):
				logInput(4)
	else:
		$interactionArea/TextureRect.visible = false
		$inputHandler.visible = false

#adds D-pad UI elements to input screen
func logInput(input):
	inputArr.append(input)
	var i = inputRects.instantiate()
	match input:
		1:
			i.get_child(0).texture = arrowUpTexture
		2:
			i.get_child(0).texture = arrowRightTexture
		3:
			i.get_child(0).texture = arrowDownTexture
		4:
			i.get_child(0).texture = arrowLeftTexture
	$SFX/inputSound.play()
	$inputHandler/HBoxContainer.add_child(i)

#clears input screen and input array
func clearInputLog():
	for i in $inputHandler/HBoxContainer.get_children():
		i.queue_free()
	inputArr = []

func checkInput(inputArray):
	if inputArray == inputCode:
		$SFX/openSound.play()
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		$CollisionShape2D.disabled = true
		$interactionArea/TextureRect.queue_free()
		$inputHandler/Panel.visible = false
		$interactionArea.queue_free()
		isUnlocked = true
	

func _on_interaction_area_body_entered(body):
	bodyEntered = true
	emit_signal('playerNearDoor', bodyEntered)


func _on_interaction_area_body_exited(body):
	bodyEntered = false
	emit_signal('playerNearDoor', bodyEntered)

func ghostCode():
	$inputHandler/Panel.visible = true
