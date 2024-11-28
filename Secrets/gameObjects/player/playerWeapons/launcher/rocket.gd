extends CharacterBody2D

const SPEED = 700
var moveVector = Vector2.ZERO
var boom = false

func _ready():
	pass

func _physics_process(delta):
	if !boom:
		var collision = move_and_collide(moveVector*SPEED*delta)
		if collision:
			if collision.get_collider().has_method("takeDamage"):
				collision.get_collider().takeDamage()
			explode()

func explode():
	boom = true
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.visible = false
	$explosion/CollisionShape2D.disabled = false
	$explosion/AnimatedSprite2D.visible = true
	$explosion/AnimatedSprite2D.play("boom")
	$boomSound.play()


func _on_hitbox_body_entered(body):
	body.takeDamage()
	queue_free()

func _on_explosion_body_entered(body):
	body.takeDamage(10)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
