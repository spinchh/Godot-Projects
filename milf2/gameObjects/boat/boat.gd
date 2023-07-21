extends CharacterBody2D

const SPEED = 300.0
const GRAVITY = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("moveLeft"):
		velocity.x = lerp(velocity.x, -SPEED, 0.03)
	elif Input.is_action_pressed("moveRight"):
		velocity.x = lerp(velocity.x, SPEED, 0.03)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.015)
	
	velocity.y = 0
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


