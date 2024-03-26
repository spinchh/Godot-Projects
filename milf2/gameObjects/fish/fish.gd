extends CharacterBody2D

enum STATES {FREE, HOOKED}

#variables to be assigned by spawner 
var fishName: String = ""
var value = 1
var swimSpeed = null
var spritePath = null

var isLoaded = false
var spriteSheet = null
var spriteResource = null


func _ready():
	pass

func _physics_process(delta):
	if spriteSheet != null and isLoaded == false:
		spriteResource = load(spriteSheet)
		startSprite()
		isLoaded = true

func startSprite():
	$AnimatedSprite2D.set_sprite_frames(spriteResource)
	$AnimatedSprite2D.play(fishName)

func gotHooked(hook):
	set_collision_layer_value(5, false)
	await get_tree().process_frame
	get_parent().remove_child(self)
	hook.get_node("fishHolder").add_child(self)
	global_position = hook.position
