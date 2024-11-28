extends CharacterBody2D

signal hasDied

var velocity = Vector2(0, 0)
var speed = -75
var ded = false
var damageDealt = 1

@export var fastBoy = false
@export var switchTime = 5
@export var facingRight = true
@export var goesUpwardsFirst = true


func _ready():
	if ded == true:
		velocity.y = velocity.y + 35
		$Timer.stop()
	if facingRight == true:
		$sprite.flip_h = true
	if goesUpwardsFirst == false:
		speed = speed * -1
	if fastBoy == true:
		damageDealt = 2
		set_modulate(Color(2, .5, .5))
		speed = speed * 3
		switchTime = switchTime * .33
	$Timer.start(switchTime)

func _physics_process(delta):
	velocity.x = 0
	velocity.y = speed
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity	

func _on_Timer_timeout():
	speed = speed * -1
	$Timer.start(switchTime)

func _on_topChecker_body_entered(body):
	body.bounce()
	emit_signal("hasDied")
	isDead()
	
func isDead():
	set_physics_process(false)
	
	$sprite.play("dead")
		
	set_collision_layer_value(7, false)
	$sidechecker.set_collision_mask_value(0, false)
	$sidechecker.set_collision_mask_value(5, false)
	
	$topChecker.set_collision_mask_value(0, false)
	
	$deathSound.play()
	
	$AnimationPlayer.play("dead")
	
	await get_tree().create_timer(1).timeout
	
	queue_free()

func _on_sidechecker_body_entered(body):
	body.knockback(position.x, damageDealt)
	print("ouch")


func _on_Area2D_body_entered(body):
	isDead()
