extends CharacterBody2D

var speed = -500
var velocity = Vector2(0,0)

func _ready():
	$Sprite2D.play('default')
	velocity.x = speed

func _physics_process(delta):
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity    
	if is_on_floor():
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	body.knockback(position.x, 1)
	queue_free()
	
