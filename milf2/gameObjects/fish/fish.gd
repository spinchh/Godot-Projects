extends CharacterBody2D

enum STATES {FREE, HOOKED}

#variables to be assigned by spawner 
var fishName: String = ""
var value = 1
var swimSpeed = null
var spritePath = null

var alreadyHooked = false

func _ready():
	pass

func _physics_process(delta):
	if spritePath:
		var texture = load(spritePath)
		$Sprite2D.set_texture(texture)

func gotHooked(hook):
	set_collision_layer_value(5, false)
	await get_tree().process_frame
	get_parent().remove_child(self)
	hook.get_node("fishHolder").add_child(self)
	global_position = hook.position
