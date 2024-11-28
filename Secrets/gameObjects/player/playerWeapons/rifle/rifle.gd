extends Node2D

signal weaponTimeout

const PROJECTILE = preload("res://gameObjects/player/projectile.tscn")

var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$SFX/readySound.play()
	if get_parent():
		connect("weaponTimeout", Callable(get_parent(), "on_weaponTimeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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


func _on_timeout_timer_timeout():
	emit_signal("weaponTimeout")
