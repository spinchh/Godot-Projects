extends CharacterBody2D

signal damageTaken(healthRemaining)
signal shieldBroken
signal updateHud(updateType)

#state machine constants and variables
enum STATES{MOVING, SHOOTING, DEAD}
var state = STATES.MOVING

const SPEED = 250.0
const DASHSPEED = 1000.0

@onready var ITEMS = preload("res://gameObjects/resources/unlockables.tres")

#input handling for left and right sticks, respectively
var moveInput = Vector2.ZERO
var attackInput = Vector2.ZERO

#health related vars
var shieldCount = 0
var maxShieldCount = 0
var shieldActive = false

var canTakeDamage = true
var maxPlayerHealth = 4
var playerHealth = 4
var isDead = false
var canHeal = true

#state variables for dashing and shooting
var isDashing = false
var canDash = true
var canShoot = true

#play idle animation on start
func _ready():
	$AnimatedSprite2D.play("idle")
	maxShieldCount = PlayerData.playerData.maxShieldCount
	shieldCount = maxShieldCount
	if shieldCount != 0:
		shieldActive = true

func _physics_process(delta):
	#movement input handling
	moveInput.x = Input.get_action_strength("left_stick_right") - Input.get_action_strength("left_stick_left")
	moveInput.y = Input.get_action_strength("left_stick_down") - Input.get_action_strength("left_stick_up")
	
	#input handling on the right stick
	attackInput.x = Input.get_action_strength("right_stick_right") - Input.get_action_strength("right_stick_left")
	attackInput.y = Input.get_action_strength("right_stick_down") - Input.get_action_strength("right_stick_up")
	
	#dash button
	if Input.is_action_just_pressed("right_bumper") and canDash and moveInput != Vector2.ZERO:
		dash()
	
	#shielded check
	if maxShieldCount != 0:
		if shieldCount <= 0:
			shieldActive = false
			if $shieldTimer.get_time_left() <= 0:
				$shieldTimer.start()
		else:
			shieldActive = true
	
	#state check
	if isDead:
		state = STATES.DEAD
	elif attackInput != Vector2.ZERO:
		state = STATES.SHOOTING
		#controls UI aiming element
		var arrowPos = attackInput.normalized() * 30
		$Sprite2D.visible = true
		$Sprite2D.position = arrowPos
		$Sprite2D.rotation = attackInput.normalized().angle() - 64.4
	else:
		state = STATES.MOVING
		$Sprite2D.visible = false
		
	match state:
		STATES.MOVING:
			#allows shooting while moving
			canShoot = true
			#move at defined movement speed
			if !isDashing:
				velocity = moveInput * SPEED
			else:
				velocity = moveInput * DASHSPEED
			#play walk animation when moving
			if(velocity != Vector2.ZERO):
				$AnimatedSprite2D.play("walk")
			else:
				$AnimatedSprite2D.play("idle")
		STATES.SHOOTING:
			#halve movement speed while attacking
			if !isDashing:
				velocity = moveInput * (SPEED / 2)
			else:
				velocity = moveInput * DASHSPEED
			#determines time between attacks
			$weaponHandler.fireCurrentWeapon(attackInput)
		STATES.DEAD:
			velocity = Vector2.ZERO
	#flip sprite if moving/shooting leftwards
	if ((moveInput or attackInput) and (velocity.x < 0 or attackInput.x < 0)):
		$AnimatedSprite2D.flip_h = true
		$weaponHandler.flipSprite(true)
	else:
		$AnimatedSprite2D.flip_h = false
		$weaponHandler.flipSprite(false)
	
	if $AnimatedSprite2D.animation == "walk" and ($AnimatedSprite2D.frame == 1 or $AnimatedSprite2D.frame == 3) and !$SFX/footstepSound.is_playing():
		$SFX/footstepSound.play()
	
	move_and_slide()

#functions for dashing. Sets isDashing for period of time set in dashTimer, then starts cooldown.
func dash():
	#dash ghosting effect
	$GPUParticles2D.emitting = true
	isDashing = true
	canDash = false
	#disable enemy hit detection
	self.set_collision_layer_value(1, false)
	self.set_collision_mask_value(3, false)
	self.set_collision_mask_value(5, false)
	$dashTimer.start()
	$SFX/dashSound.play()

func takeDamage():
	if canTakeDamage == true:
		canTakeDamage = false
		#disable enemy hit detection
		self.set_collision_mask_value(5, false)
		#break shield if active. Start shield recharge, give invuln for after hit
		if shieldActive:
			$SFX/shieldSound.play()
			shieldCount -= 1
			emit_signal("shieldBroken")
			shieldActive = false
			$shieldTimer.start()
			await get_tree().create_timer(1).timeout
			self.set_collision_mask_value(5, true)
			canTakeDamage = true
		else:
			#player takes 1 health damage. restart shield recharge timer
			playerHealth = playerHealth - 1
			emit_signal("damageTaken", playerHealth)
			emit_signal("shieldBroken")
			#die if hp hits zero
			if playerHealth <= 0:
				isDead = true
				die()
				return
			$shieldTimer.start()
			$SFX/hitSound.play()
			#hit flash
			$AnimatedSprite2D.material.set("shader_param/flash_white" , true)
			await get_tree().create_timer(.1).timeout
			$AnimatedSprite2D.material.set("shader_param/flash_white" , false)
			#reset hit detection
			$AnimatedSprite2D.material.set("shader_param/translucent" , true)
			await get_tree().create_timer(3).timeout
			$AnimatedSprite2D.material.set("shader_param/translucent" , false)
			self.set_collision_layer_value(1, true)
			self.set_collision_mask_value(5, true)
			canTakeDamage = true

#remove player as enemy target, disable collision, play death animation. Reset level after 5 seconds.

func die():
	$SFX/deathSound.play()
	get_tree().call_group("enemies", "playerDied")
	set_collision_layer_value(1, false)
	set_collision_mask_value(5, false)
	$weaponHandler.visible = false
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()

#bridges input screen to weapon handler. ugly and unneccessary but idk how else to do it
#TODO: set this to be handled with a signal.
func swapWeapon(newWeapon):
	$weaponHandler.swapWeapon(newWeapon)

func _on_dash_cooldown_timeout():
	canDash = true

func _on_dash_timer_timeout():
	$GPUParticles2D.emitting = false
	isDashing = false
	self.set_collision_layer_value(1, true)
	self.set_collision_mask_value(3, true)
	self.set_collision_mask_value(5, true)
	$dashCooldown.start()


func _on_shield_timer_timeout():
	shieldCount += 1
	if shieldCount < maxShieldCount:
		$shieldTimer.start()


func _on_input_screen_upgrade_unlocked(upgradeID):
	var upgrade = upgradeID.itemType
	match upgrade:
		"SHIELD":
			$SFX/upgradeSound.play()
			maxShieldCount += 1
			shieldCount += 1
			shieldActive = true
			PlayerData.addShields()
			emit_signal("updateHud", "SHIELD")
			upgradeID.isUnlocked = true
		"REPAIR":
			if canHeal:
				playerHealth = maxPlayerHealth
				emit_signal("updateHud", "REPAIR")
				canHeal = false
				$repairTimer.start()


func _on_repair_timer_timeout():
	canHeal = true
