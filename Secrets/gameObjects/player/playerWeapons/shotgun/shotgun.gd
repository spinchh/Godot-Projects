extends Node2D

signal weaponTimeout

const PROJECTILE = preload("res://gameObjects/player/playerWeapons/shotgun/shotgun_projectile.tscn")

var canShoot = true

var shotCount = 8
var arcAngle =	15


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
		canShoot = false
		var baseAngle = attackInput.angle()
		var startAngle = baseAngle - deg_to_rad(arcAngle/2)
		var angleStep = deg_to_rad(arcAngle / (shotCount - 1))
		for i in range(shotCount):
			$SFX/shootSound.play()
			var currentAngle = startAngle + (i * angleStep)
			var dir = Vector2(cos(currentAngle), sin(currentAngle))
			var p = PROJECTILE.instantiate()
			p.position = global_position
			p.rotation = attackInput.angle()
			p.moveVector = dir.normalized()
			get_tree().get_root().add_child(p)
			$Timer.start()

func _on_timer_timeout():
	canShoot = true

func _on_timeout_timer_timeout():
	emit_signal("weaponTimeout")
