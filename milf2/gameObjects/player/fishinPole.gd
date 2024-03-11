extends Node2D

const FISHHOOK = preload("res://gameObjects/hook/hook.tscn")
enum STATES{CAST, REEL}

#state machine declaration
var state = STATES.CAST
#initial position. used for clamping distance from initial position
var initialPos = Vector2.ZERO
#determines maximum distance from initialPos
#var lineLength = Vector2(300,300)
var lineLength = 300
var tempLineLength = 0
#determines current distance from initial position
var castLength = Vector2()
#determines speed at which the hook is reeled back in
var reelSpeed = 2
var reelStrength = 15

var forceMultiplier = 3.0

#state variable preventing multiple lures from being created
var canCast = true
#local reference to spawned hook
var hookChild = null
# Called when the node enters the scene tree for the first time.
func _ready():
	resetLineLength()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hookChild != null:
		var hookDir = hookChild.global_position.direction_to(self.global_position)
		castLength = global_position.distance_to(hookChild.global_position)
		if castLength >= tempLineLength:
			hookChild.reelHook(hookDir, reelStrength)
		if Input.is_action_pressed("ui_touch"):
			tempLineLength = tempLineLength - reelSpeed
	
func resetLineLength():
	tempLineLength = 0

func launchHook(force : Vector2):
	#state = STATES.REEL
	#vectorCreator.set_collision_layer_bit(3, false)
	tempLineLength = lineLength
	var vector = force
	var initialPosition = $castPoint.global_position
	var hook = FISHHOOK.instantiate()
	hookChild = hook
	hook.connect("fishClaimed", claimFish)
	#hook.connect("reeledIn", self, "addCash")
	#hook.connect("sploosh", self, "sploosh")
	
	hook.global_position = initialPosition
	#self.add_child(hook)
	get_tree().get_root().add_child(hook)
	hook.launchHook(force)
	#$castSound.play()

func _on_vector_creator_vector_created(force):
	if canCast:
		launchHook(force)
		canCast = false

func claimFish():
	canCast = true
