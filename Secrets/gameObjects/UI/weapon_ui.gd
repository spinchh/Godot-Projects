extends Control

@export var itemName = "PISTOL"
@export var isOnCooldown = false

#preloaded item dictionary and d-pad UI elements
@onready var items = preload("res://gameObjects/resources/unlockables.tres")
@onready var inputRects = preload("res://gameObjects/UI/inputRect.tscn")

var arrowUpTexture = preload("res://art/Custom/UI/arrowUp.png")
var arrowDownTexture = preload("res://art/Custom/UI/arrowDown.png")
var arrowLeftTexture = preload("res://art/Custom/UI/arrowLeft.png")
var arrowRightTexture = preload("res://art/Custom/UI/arrowRight.png")

@onready var itemResource = null
var percentTimeLeft
var isUnlocked = false


# Called when the node enters the scene tree for the first time.
func _ready():
	itemResource = items.items[itemName]
	isUnlocked = itemResource.isUnlocked
	var itemImage = ResourceLoader.load(itemResource.imageRef)
	$Panel/TextureRect.texture = itemImage
	for i in itemResource.inputCode:
		logInput(i)
	if isUnlocked == false:
		$Panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isOnCooldown:
		$Panel2.visible = true
		if $Panel2/Timer.get_time_left() > 0:
			percentTimeLeft = -(1-$Panel2/Timer.get_time_left() / $Panel2/Timer.get_wait_time() * 100)
			$Panel2/TextureProgressBar.value = percentTimeLeft

func logInput(input):
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
	$Panel/HBoxContainer.add_child(i)

func weaponTimeout(weaponID):
	if items.items[itemName].ID == weaponID:
		isOnCooldown = true
		$Panel2/Timer.start(items.items[itemName].cooldown)
		$SFX/timeoutSound.play()

func weaponSelected():
#	if items.items[itemName].ID == weaponID:
	isOnCooldown = true

func weaponUnlocked(weaponID):
	if items.items[itemName].ID == weaponID:
		$Panel.visible = true
		isUnlocked = true

func _on_timer_timeout():
	$Panel2.visible = false
	$SFX/rechargeSound.play()
	isOnCooldown = false
