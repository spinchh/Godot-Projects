extends RigidBody2D

signal fishClaimed

enum STATES{CAST, REEL}

var isUnderWater = false
var forceMultiplier = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isUnderWater:
		self.linear_damp = 10
	else:
		self.linear_damp = .1
	
func reelHook(hookDir, reelStrength):
	var reelDir = hookDir * reelStrength
	apply_impulse(reelDir, Vector2.ZERO)

func launchHook(force):
	apply_impulse(force * forceMultiplier, Vector2.ZERO)

func claimFish():
	emit_signal("fishClaimed")
	print('fish claimed')
	queue_free()

func caughtFish():
	#fishCaught += 1
	pass

func _on_bite_box_body_entered(body):
	body.gotHooked(self)
	#body.set_collision_layer_bit(1, false)
	caughtFish()

func _on_water_detector_area_entered(area):
	isUnderWater = !isUnderWater
