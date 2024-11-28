extends CharacterBody2D

const GRAVITY = 35

signal hasDied

var velocity = Vector2(0, 0)
var speed = 50
var beefy = false
var dead = false

@export var damageDealt = 1
@export var direction = -1
@export var detectEdge = true

func _ready():
	if direction == 1:
		$Sprite2D.flip_h = true
	$floorChecker.position.x = $hitbox.shape.get_extents().x * direction
	$floorChecker.enabled = detectEdge
	
	if detectEdge:
		set_modulate(Color(.3, 1.2, .3))
	
	if beefy:
		set_modulate(Color(.5, .5, 2))
		damageDealt = 2
		speed = 65

func _physics_process(delta):
	if is_on_wall() or not $floorChecker.is_colliding() and detectEdge and is_on_floor() :
		direction = direction * -1
		$Sprite2D.flip_h = not $Sprite2D.flip_h
		$floorChecker.position.x = $hitbox.shape.get_extents().x * direction
	
	velocity.y = velocity.y + GRAVITY 
	velocity.x = speed * direction
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity


func _on_topChecker_body_entered(body):
	body.bounce()
	emit_signal("hasDied")
	isDead()
	$deathSound.play()
	dead = true

func respawn():
	$Sprite2D.play()

func isDead():
	$Sprite2D.play("dead")
	$Sprite2D.position.y = 13
	speed = 0
	
	set_collision_layer_value(4, false)
	set_collision_mask_value(0, false)
	
	$topChecker.set_collision_layer_value(4, false)
	$topChecker.set_collision_mask_value(0, false)
	
	$sideChecker.set_collision_mask_value(0, false)
	
	
	
	await get_tree().create_timer(1).timeout
	
	
	queue_free()
	
	
func _on_sideChecker_body_entered(body):
	body.knockback(position.x, damageDealt)
	

