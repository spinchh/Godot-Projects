extends CharacterBody2D

var velocity = Vector2(0,0)
var direction = 1

const SPEED = -800
const GRAVITY = 30
const BOUNCE = -250

func _ready():
	velocity.x = SPEED * direction

func _physics_process(delta):
	$Sprite2D.rotation_degrees += 15 * -direction
	
	velocity.y += GRAVITY
	
	if is_on_wall():
		queue_free()
	
	if is_on_floor():
		velocity.y = BOUNCE
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity    

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_hitbox_body_entered(body):
	body.isDead()
	$soundHit.play()
	await get_tree().create_timer(.1).timeout
	queue_free()
