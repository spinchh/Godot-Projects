extends Node2D

const FISHHOOK = preload("res://gameObjects/hook/hook.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func launchHook(force : Vector2):
	#state = STATES.REEL
	#vectorCreator.set_collision_layer_bit(3, false)
	
	var vector = force
	var initialPosition = $castPoint.global_position
	var hook = FISHHOOK.instantiate()
	#hook.connect("reeledIn", self, "addCash")
	#hook.connect("sploosh", self, "sploosh")
	
	hook.global_position = initialPosition
	get_tree().get_root().add_child(hook)
	hook.launchHook(force)
	#$castSound.play()

func _on_vector_creator_vector_created(force):
	launchHook(force)

func _on_claim_area_body_entered(body):
	body.claimFish()
