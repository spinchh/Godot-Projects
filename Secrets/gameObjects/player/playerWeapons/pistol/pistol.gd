extends Node2D

const PROJECTILE = preload("res://gameObjects/player/playerWeapons/shotgun/shotgun_projectile.tscn")

var canShoot = true

func _ready():
	$SFX/readySound.play()

func fire(attackInput):
#	$AnimatedSprite2D.play("shoot")
	if canShoot:
		$SFX/shootSound.play()
		canShoot = false
		var p = PROJECTILE.instantiate()
		p.position = global_position
		p.rotation = attackInput.angle()
		p.moveVector = attackInput.normalized()
		get_tree().get_root().add_child(p)
		$Timer.start()

func _on_timer_timeout():
	canShoot = true
