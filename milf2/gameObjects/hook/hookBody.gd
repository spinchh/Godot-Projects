extends RigidBody2D

signal fishClaimed

enum STATES{CAST, REEL}

var isUnderWater = false
var totalValue = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isUnderWater:
		self.linear_damp = 10
	else:
		self.linear_damp = 2

#if at tempLineLength distance, apply vector pointing towards the player
func reelHook(hookDir, reelStrength):
	var reelDir = hookDir * reelStrength
	apply_impulse(reelDir, Vector2.ZERO)

#launch hook at given vector force
func launchHook(force, forceMultiplier):
	apply_impulse(force * forceMultiplier, Vector2.ZERO)

#total up all fish values
func claimFish():
	var fishCaught = 0
	for fish in $fishHolder.get_children():
		fishCaught += 1
		totalValue += fish.value
	emit_signal("fishClaimed", totalValue, fishCaught)
	queue_free()

func _on_bite_box_body_entered(body):
	body.gotHooked(self)

func _on_water_detector_area_entered(area):
	isUnderWater = !isUnderWater
