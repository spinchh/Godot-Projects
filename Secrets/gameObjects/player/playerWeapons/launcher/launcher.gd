extends Node2D

signal weaponTimeout

var ROCKET = preload("res://gameObjects/player/playerWeapons/launcher/rocket.tscn")

var canShoot = true

func _ready():
	$SFX/readySound.play()
	if get_parent():
		connect("weaponTimeout", Callable(get_parent(), "on_weaponTimeout"))

func fire(attackInput):
#	$AnimatedSprite2D.play("shoot")
	if canShoot:
		$SFX/shootSound.play()
		canShoot = false
		var r = ROCKET.instantiate()
		r.position = global_position
		r.rotation = attackInput.angle()
		r.moveVector = attackInput.normalized()
		get_tree().get_root().add_child(r)
		$Timer.start()

func _on_timer_timeout():
	canShoot = true


func _on_timeout_timer_timeout():
	emit_signal("weaponTimeout")
