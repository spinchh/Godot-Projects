extends KinematicBody2D

signal dead

var velocity = Vector2(0,0)
var speed = 5500
var crownHealth = 15
var bossHealth = 9
var projectileSpeed = -2000

var timesInARowTheCrownHasBeenHit = 0
var hasFiredProjectile = false
var crownIsAlive = true

const GRAVITY = 50
const JUMPFORCE = -2650
const PROJECTILE = preload("res://assets/scenes/kingSlimeProjectile.tscn")

var tickCycle = 5
var cycleCount = 0
var projectileDelay = 2

func _ready():
	set_physics_process(false)
	$mainSprite.play("idle")
	$topChecker.set_collision_mask_bit(0, false)
	$crown/crownAnimationPlayer.play("default")

func _physics_process(delta):
	if !is_on_floor():	
		velocity.y = velocity.y + GRAVITY
	
	velocity.x = lerp(velocity.x, 0, .05)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if $Sightline.is_colliding():
		fireProjectile()

func takeAction():
	match cycleCount:
		0:
			fireProjectile()
		1:
			straightJump()
		2:
			straightJump()
		3:
			fireProjectile()
		4:
			forwardJump()
		5:
			fireProjectile()
			print("cycle reset")
			cycleCount = 0
	$mainSprite.play("idle")

func takeDamage():
	bossHealth = bossHealth - 1
	$mainAnimationPlayer.play("damage")
	$soundDamage.play()
	updatePhase()
	print(bossHealth)
	if bossHealth == 0:
		$mainAnimationPlayer.play("dead")
		$soundDeath.play()
		set_physics_process(false)
		$actionTimer.stop()
		$topChecker.set_collision_mask_bit(0, false)
		$sideChecker.set_collision_mask_bit(0, false)
		yield(get_tree().create_timer(1.9), "timeout")
		emit_signal("dead")
		PlayerVariables.bosses['kingSlime'] = true
		queue_free()
		

func updatePhase():
		if bossHealth == 9:
			tickCycle = 4
			projectileDelay = 1.5
			projectileSpeed = -1750
			print('phase 1')
			$soundAngery.play()
		elif bossHealth == 6:
			tickCycle = 3
			projectileDelay = 1
			projectileSpeed = -1500
			set_modulate(Color(1.5, .9, 1.5))
			print('phase 2')
			$soundAngery.play()
		elif bossHealth == 3:
			tickCycle = 2
			projectileDelay = .5
			set_modulate(Color(2, .5, .5))
			print('phase 3')
			$soundAngery.play()
func crownDied():
	updatePhase()
	$soundCrownDeath.play()
	$crown/crownAnimationPlayer.play("death")
	print('crown dead')
	yield(get_tree().create_timer(1), "timeout")
	$crown.queue_free()
	$sideChecker/firstPhase.disabled = true
	$topChecker.set_collision_mask_bit(0, true)

func crownDamage():
	print('crown hit')
	$soundCrownDamage.play()
	crownHealth = crownHealth - 1
	timesInARowTheCrownHasBeenHit = timesInARowTheCrownHasBeenHit + 1
	$crown/crownAnimationPlayer.play("damage")
	
	if timesInARowTheCrownHasBeenHit == 4:
		straightJump()
		timesInARowTheCrownHasBeenHit = 0
	
	yield(get_tree().create_timer(.1), "timeout")
	$crown/crownAnimationPlayer.play("default")

func straightJump():
	if is_on_floor():
		$soundAngery.play()
		print('straight jump')
		velocity.y = JUMPFORCE
		yield(get_tree().create_timer(1), "timeout")
		fireProjectile()

func forwardJump():
	print("forward jump")
	$soundAngery.play()
	$Sightline.set_collision_mask_bit(0, false)
	
	velocity.x = -speed
	velocity.y = JUMPFORCE * .8
	
	yield(get_tree().create_timer(5), "timeout")
	
	velocity.x = speed
	velocity.y = JUMPFORCE * .8
	$soundAngery.play()
	
	$Sightline.set_collision_mask_bit(0, true)


func fireProjectile():
	if !hasFiredProjectile:
		$soundProjectile.play()
		$mainSprite.play("spit")
		
		var p = PROJECTILE.instance()
		
		p.speed = projectileSpeed
		
		get_parent().add_child(p)
		
		p.position.x = position.x - 500
		p.position.y = position.y - 70
		
		hasFiredProjectile = true
		$delayTimer.start(projectileDelay)
		
		yield(get_tree().create_timer(.5), "timeout")
		$mainSprite.play('idle')
	
func _on_crown_body_entered(body):
	body.queue_free()
	if crownHealth >= 1 and crownIsAlive:
		crownDamage()
	elif crownIsAlive:
		$crown.set_collision_mask_bit(5, false)
		crownIsAlive = false
		crownDied()
		

func _on_delayTimer_timeout():
	hasFiredProjectile = false

func _on_actionTimer_timeout():
	takeAction()
	$actionTimer.start(tickCycle)
	cycleCount = cycleCount + 1

func _on_AI_trigger_body_entered(body):
	set_physics_process(true)
	$actionTimer.start(tickCycle)
	$"AI trigger".set_collision_mask_bit(0, false)
	print('start')

func _on_topChecker_body_entered(body):
	takeDamage()
	body.bossBounce(position.x)

func _on_sideChecker_body_entered(body):
	body.knockback(position.x, 1)


func _on_mainAnimationPlayer_animation_finished(anim_name):
	$mainAnimationPlayer.play("default")
