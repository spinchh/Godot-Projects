extends CharacterBody2D

enum STATES {FREE, HOOKED}

#variables to be assigned by spawner 
var fishName: String = ""
var value = null
var swimSpeed = null
var spritePath = null

func _ready():
	pass

func _physics_process(delta):
	pass

func gotHooked(hook):
	#$Timer.stop()
	#state = STATES.HOOKED
	await get_tree().process_frame
	get_parent().remove_child(self)
	hook.get_node("fishHolder").add_child(self)
	global_position = hook.position
