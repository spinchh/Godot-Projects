extends Node2D

const FISHHOOK = preload("res://gameObjects/hook/hook.tscn")
enum STATES{CAST, REEL}

#state machine declaration
var state = STATES.CAST
#initial position. used for clamping distance from initial position
var initialPos = Vector2.ZERO
#determines maximum distance from initialPos
#var lineLength = Vector2(300,300)
var lineLength = 3000
var tempLineLength = 0
#determines current distance from initial position
var castLength = Vector2()
#determines speed at which the hook is reeled back in
var reelSpeed = 5
var reelStrength = 60
#determines the strength of the cast, multiplies the force vector in launchHook
var forceMultiplier = 10.0

#state variable preventing multiple lures from being created
var canCast = true
#local reference to spawned hook
var hookChild = null
#reference to camera child
@onready var cameraChild = $Camera2D
var hasChangedCamera = false
# Called when the node enters the scene tree for the first time.
func _ready():
	resetLineLength()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hookChild != null:
		var hookDir = hookChild.global_position.direction_to(self.global_position)
		castLength = global_position.distance_to(hookChild.global_position)
		if castLength > 100 and hasChangedCamera == false:
			var tween = create_tween()
			tween.tween_property(cameraChild, 'position', hookChild.position, .75)
			if !tween.is_running():
				hookChild.takeCamera()
		if castLength >= tempLineLength:
			hookChild.reelHook(hookDir, reelStrength)
		if Input.is_action_pressed("ui_touch"):
			tempLineLength = castLength
			tempLineLength = tempLineLength - reelSpeed

#Resets working line length to 0
func resetLineLength():
	tempLineLength = 0

#spawn and launch hook at vector given by vectorCreator
func launchHook(force : Vector2):
	#state = STATES.REEL
	tempLineLength = lineLength
	var vector = force
	var initialPosition = $castPoint.global_position
	var hook = FISHHOOK.instantiate()
	hookChild = hook
	hook.connect("fishClaimed", claimFish)
	#hook.connect("reeledIn", self, "addCash")
	#hook.connect("sploosh", self, "sploosh")
	
	hook.global_position = initialPosition
	get_tree().get_root().add_child(hook)
	hook.launchHook(force, forceMultiplier)
	#$castSound.play()

#prevents multiple lures from being out at once
func _on_vector_creator_vector_created(force):
	if canCast:
		launchHook(force)
		canCast = false

#update money value in Globals
func claimFish(value, fishCaught):
	var currentMoney = PlayerData.playerValues["money"]
	var newMoney = currentMoney + value
	PlayerData.playerValues["money"] = newMoney
	
#	var tween = create_tween()
#	tween.tween_property(hookChild.position, 'position', hookChild.position, .75)
	
	get_parent().emit_signal("updateHUD")
	get_parent().emit_signal("updateFishSpawner", fishCaught)
	
	canCast = true

func cameraTransition():
	var tween = create_tween()
	tween.tween_property(cameraChild, 'position', hookChild.position, .75)
