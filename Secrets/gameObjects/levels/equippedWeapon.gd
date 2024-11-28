extends Control

@export var player = Node2D
@onready var percentTimeLeft

var pistolSprite = preload("res://art/Custom/pistol.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left_trigger"):
		self.visible = false
	else:
		self.visible = true
	
	if $Panel/Timer.get_time_left() > 0:
		percentTimeLeft = -(1-$Panel/Timer.get_time_left() / $Panel/Timer.get_wait_time() * 100)
		$Panel/TextureProgressBar.value = percentTimeLeft

func _on_input_screen_weapon_changed(newWeapon):
	$Panel/TextureRect.texture = ResourceLoader.load(newWeapon.imageRef)
	$Panel/Timer.start(newWeapon.timeOut)


func _on_timer_timeout():
	$Panel/TextureRect.texture = pistolSprite
