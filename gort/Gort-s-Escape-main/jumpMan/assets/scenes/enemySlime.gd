extends KinematicBody2D

const GRAVITY = 35

signal hasDied

var velocity = Vector2(0, 0)
var speed = 50
var beefy = false
var dead = false

export var damageDealt = 1
export var direction = -1
export var detectEdge = true

func _ready():
	if direction == 1:
		$Sprite.flip_h = true
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
		$Sprite.flip_h = not $Sprite.flip_h
		$floorChecker.position.x = $hitbox.shape.get_extents().x * direction
	
	velocity.y = velocity.y + GRAVITY 
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_topChecker_body_entered(body):
	body.bounce()
	emit_signal("hasDied")
	isDead()
	$deathSound.play()
	dead = true

func respawn():
	$Sprite.play()

func isDead():
	$Sprite.play("dead")
	$Sprite.position.y = 13
	speed = 0
	
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	
	$topChecker.set_collision_layer_bit(4, false)
	$topChecker.set_collision_mask_bit(0, false)
	
	$sideChecker.set_collision_mask_bit(0, false)
	
	
	
	yield(get_tree().create_timer(1), "timeout")
	
	
	queue_free()
	
	
func _on_sideChecker_body_entered(body):
	body.knockback(position.x, damageDealt)
	

