extends KinematicBody2D

signal spawnItemDrop

const GRAVITY = 35
const JUMPFORCE = -1500
const FIREBALL = preload("res://assets/scenes/lavaSlimeFireball.tscn")

var velocity = Vector2(0,0)
var speed = 2500
var damageDealt = 1
var health = 9
var direction = 1

var initialPosition = null

var tickCycle = 3
var cycleCount = 0

func _ready():
	initialPosition = position.x
	$AnimationPlayer.play('idle')
	set_physics_process(false)

func _physics_process(delta):
	if !is_on_floor():	
		velocity.y = velocity.y + GRAVITY
		
	if $sightLine.is_colliding() or $sightLine2.is_colliding():
		direction = direction * -1
		$sightLine.cast_to = $sightLine.cast_to * -1
		$sightLine2.cast_to = $sightLine2.cast_to * -1
		$Sprite.flip_h = !$Sprite.flip_h
		
	velocity.x = lerp(velocity.x, 0, .05)
	velocity = move_and_slide(velocity, Vector2.UP)

func takeAction():
	if cycleCount % 2 == 0:
		fireball()
	elif cycleCount % 3 == 0:
		straightJump()
		fireball()
	elif cycleCount % 5 == 0:
		forwardJump()

func straightJump():
	velocity.y = JUMPFORCE
	yield(get_tree().create_timer(.6), "timeout")
	fireball()

func forwardJump():
	
	$sightLine.enabled = false
	
	velocity.x = -speed * direction
	velocity.y = JUMPFORCE * .8
	
	yield(get_tree().create_timer(3), "timeout")
	
	if position.x < initialPosition:
		velocity.x = speed * direction
		velocity.y = JUMPFORCE * .8
	elif position.x > initialPosition:
		velocity.x = speed * -direction
		velocity.y = JUMPFORCE * .8
	$sightLine.enabled = true

func fireball():
	var f = FIREBALL.instance()
	f.direction = direction
	
	get_parent().add_child(f)
		
	f.position.y = position.y
	f.position.x = position.x
	$soundFireball.play()

func updatePhase():
	if health == 9:
		tickCycle = 3
		print('first phase')
		$soundAngery.play()
	elif health == 6:
		tickCycle = 2
		set_modulate(Color(1.2, 1, 1))
		print('second phase')
		$soundAngery.play()
	elif health == 3:
		tickCycle = 1 
		set_modulate(Color(1.8, 1, 1))
		print('third phase')
		$soundAngery.play()

func damage():
	health = health - 1
	updatePhase()
	$soundDamage.play()
	
	if health <= 0:
		$Sprite.play("dead")
		$AnimationPlayer.play('dead')
		$Timer.stop()
		$topChecker.set_collision_mask_bit(0,false)
		$sideChecker.set_collision_mask_bit(0, false)
		$soundDeath.play()
		
		yield(get_tree().create_timer(2), "timeout")
		emit_signal("spawnItemDrop")
		PlayerVariables.bosses['lavaSlime'] = true
		queue_free()
	else:
		$AnimationPlayer.play("hurt")
		$topChecker.set_collision_mask_bit(0,false)
		$topChecker.set_collision_mask_bit(1,true)
		
		yield(get_tree().create_timer(2), "timeout")
		
		$topChecker.set_collision_mask_bit(1, false)
		$topChecker.set_collision_mask_bit(0, true)

func _on_Timer_timeout():
	takeAction()
	cycleCount = cycleCount + 1
	$Timer.start(tickCycle)
	if cycleCount >= 12:
		cycleCount = 0

func _on_topChecker_body_entered(body):
		damage()
		body.bossBounce(position.x)


func _on_sideChecker_body_entered(body):
	body.knockback(position.x, damageDealt)




func _on_AI_trigger1_body_entered(body):
	set_physics_process(true)
	$"AI trigger1".set_collision_mask_bit(0, false)
	$Timer.start()
