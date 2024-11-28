extends CharacterBody2D

const SPEED = 1000

var moveVector = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	var collision = move_and_collide(moveVector*SPEED*delta)
	if collision:
		queue_free()

func _on_hitbox_body_entered(body):
	body.takeDamage()
	queue_free()

func _on_timer_timeout():
	queue_free()
