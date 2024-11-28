extends KinematicBody2D

signal hasDied

var velocity = Vector2(0, 0)
var speed = -75
var ded = false
var damageDealt = 1

export var fastBoy = false
export var switchTime = 5
export var facingRight = true
export var goesUpwardsFirst = true


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
	velocity = move_and_slide(velocity, Vector2.UP)	

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
		
	set_collision_layer_bit(7, false)
	$sidechecker.set_collision_mask_bit(0, false)
	$sidechecker.set_collision_mask_bit(5, false)
	
	$topChecker.set_collision_mask_bit(0, false)
	
	$deathSound.play()
	
	$AnimationPlayer.play("dead")
	
	yield(get_tree().create_timer(1), "timeout")
	
	queue_free()

func _on_sidechecker_body_entered(body):
	body.knockback(position.x, damageDealt)
	print("ouch")


func _on_Area2D_body_entered(body):
	isDead()
