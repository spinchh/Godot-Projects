extends RigidBody2D

enum STATES{CAST, REEL}

#state machine declaration
var state = STATES.CAST
#initial position. used for clamping distance from initial position
var initialPos = Vector2.ZERO
#determines maximum distance from initialPos
var lineLength = 300
#determines current distance from initial position
var castLength = Vector2()
#determines speed at which the hook is reeled back in
var reelSpeed = 3

var forceMultiplier = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = 0
	match state:
		#initial state. Distance is limited by lineLength. 
		STATES.CAST:
			global_position = global_position.limit_length(lineLength)
			castLength = global_position.distance_to(initialPos)
			if Input.is_action_pressed("ui_touch"):
				state = STATES.REEL
		STATES.REEL:
			global_position = position.limit_length(castLength)
			
			if Input.is_action_pressed("ui_touch"):
				#if $RayCast2D.is_colliding():
				#	apply_impulse(Vector2.ZERO, Vector2(0, -3))
				#	castLength = castLength - reelSpeed/3
				apply_impulse(Vector2.ZERO, Vector2(0, -.5))
				castLength = castLength - reelSpeed
			
			if castLength < 0:
				claimFish()
	
func launchHook(force):
	apply_impulse(force * forceMultiplier, Vector2.ZERO)

func claimFish():
	queue_free()

func caughtFish():
	#fishCaught += 1
	pass

func _on_bite_box_body_entered(body):
	body.gotHooked(self)
	#body.set_collision_layer_bit(1, false)
	caughtFish()
