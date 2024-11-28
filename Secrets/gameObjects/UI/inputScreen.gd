extends Control

signal weaponChanged(weaponID)
signal upgradeUnlocked(upgradeID)

#array for storing d-pad inputs
var inputArr = []

@export var player = Node2D

#preloaded item dictionary and d-pad UI elements
@onready var items = preload("res://gameObjects/resources/unlockables.tres")
@onready var inputRects = preload("res://gameObjects/UI/inputRect.tscn")

var arrowUpTexture = preload("res://art/Custom/UI/arrowUp.png")
var arrowDownTexture = preload("res://art/Custom/UI/arrowDown.png")
var arrowLeftTexture = preload("res://art/Custom/UI/arrowLeft.png")
var arrowRightTexture = preload("res://art/Custom/UI/arrowRight.png")

#state variable for preventing screen from appearing after confirming inputs
var toggleInputScreen = true
var playerNearDoor = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#clear array and input screen when LT is released
	if playerNearDoor:
		return
	if Input.is_action_just_released("left_trigger"):
		Engine.time_scale = 1
		toggleInputScreen = true
		checkInput(inputArr)
		clearInputLog()
		self.visible = false
	#bring up input screen while LT is pressed
	if Input.is_action_pressed("left_trigger") and toggleInputScreen:
		Engine.time_scale = .1
		self.visible = true
		#check for D-Pad inputs
		if Input.is_action_just_pressed("d_pad_up"):
			logInput(1)
		if Input.is_action_just_pressed("d_pad_right"):
			logInput(2)
		if Input.is_action_just_pressed("d_pad_down"):
			logInput(3)
		if Input.is_action_just_pressed("d_pad_left"):
			logInput(4)
		#confirm input sequence when RT is pressed. Remove input screen and 
		if Input.is_action_just_pressed("right_trigger"):
			Engine.time_scale = 1
			checkInput(inputArr)
			self.visible = false
			toggleInputScreen = false
			clearInputLog()

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
	$TextureRect/HBoxContainer.add_child(i)
	$SFX/inputSound.play()

#clears input screen and input array
func clearInputLog():
	for i in $TextureRect/HBoxContainer.get_children():
		i.queue_free()
	inputArr = []

#check input sequence against dictionary, send swap weapon signal to player
func checkInput(inputArray):
	for i in items.items:
		var itemInput = items.items[i]
		if inputArray == itemInput.inputCode:
			for child in self.get_children():
				if child.has_method("weaponTimeout") and str(itemInput.Name) == child.itemName and child.isOnCooldown == false:
					emit_signal("weaponChanged", itemInput)
					player.swapWeapon(itemInput)
					child.weaponSelected()
					if itemInput.isUnlocked == false:
						itemInput.isUnlocked = true
					$SFX/confirmSound.play()
					return
	for u in items.upgrades:
		var upgradeInput = items.upgrades[u]
		if inputArray == upgradeInput.inputCode and upgradeInput.isUnlocked == false:
			emit_signal("upgradeUnlocked", upgradeInput)
			return
	$SFX/rejectSound.play()


func _on_door_player_near_door(status):
	playerNearDoor = status


func _on_terminal_player_near_door(status):
	playerNearDoor = status
