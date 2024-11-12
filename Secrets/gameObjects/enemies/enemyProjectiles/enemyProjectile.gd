extends CharacterBody2D


const SPEED = 5

var moveVector = Vector2.ZERO


func _ready():
	pass

func _physics_process(delta):
	var collision = move_and_collide(moveVector*SPEED)
	if collision:
		queue_free()

func _on_hitbox_body_entered(body):
	body.takeDamage()
	queue_free()
