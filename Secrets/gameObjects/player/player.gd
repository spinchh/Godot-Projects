extends CharacterBody2D

#state machine constants and variables
enum STATES{MOVING, SHOOTING, DEAD}
var state = STATES.MOVING

const SPEED = 200.0
const DASHSPEED = 600.0
const PROJECTILE = preload("res://gameObjects/player/projectile.tscn")

#input handling for left and right sticks, respectively
var moveInput = Vector2.ZERO
var attackInput = Vector2.ZERO

#health related vars
var maxPlayerHealth = 3
var playerHealth = 3
var isDead = false

#state variables for dashing and shooting
var isDashing = false
var canDash = true
var canShoot = true

#play idle animation on start
func _ready():
	$AnimatedSprite2D.play("idle")
	

func _physics_process(delta):
	#movement input handling
	moveInput.x = Input.get_action_strength("left_stick_right") - Input.get_action_strength("left_stick_left")
	moveInput.y = Input.get_action_strength("left_stick_down") - Input.get_action_strength("left_stick_up")
	
	#input handling on the right stick
	attackInput.x = Input.get_action_strength("right_stick_right") - Input.get_action_strength("right_stick_left")
	attackInput.y = Input.get_action_strength("right_stick_down") - Input.get_action_strength("right_stick_up")
	
	if Input.is_action_just_pressed("right_bumper") and canDash and moveInput != Vector2.ZERO:
		dash()
	
	if isDead:
		state = STATES.DEAD
	elif attackInput != Vector2.ZERO:
		state = STATES.SHOOTING
	else:
		state = STATES.MOVING
		
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
			if canShoot:
				shootWeapon()
		STATES.DEAD:
			velocity = Vector2.ZERO
	#flip sprite if moving/shooting leftwards
	if ((moveInput or attackInput) and (velocity.x < 0 or attackInput.x < 0)):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()

func shootWeapon():
	$AnimatedSprite2D.play("shoot")
	canShoot = false
	var p = PROJECTILE.instantiate()
	p.position = self.position
	p.rotation = attackInput.angle()
	p.moveVector = attackInput.normalized()
	get_tree().get_root().add_child(p)

#functions for dashing. Sets isDashing for period of time set in dashTimer, then starts cooldown.
func dash():
	isDashing = true
	canDash = false
	$dashTimer.start()

func takeDamage():
	print(playerHealth)
	playerHealth = playerHealth - 1
	if playerHealth <= 0:
		isDead = true
		die()

func die():
	get_tree().call_group("enemies", "playerDied")
	set_collision_layer_value(0, false)
	set_collision_layer_value(1, false)
	set_collision_mask_value(5, false)
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()

func _on_dash_cooldown_timeout():
	canDash = true

func _on_dash_timer_timeout():
	isDashing = false
	$dashCooldown.start()
	
func _on_animated_sprite_2d_animation_looped():
	if $AnimatedSprite2D.animation == "shoot":
		canShoot = true
	else:
		pass
