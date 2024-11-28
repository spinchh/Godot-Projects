extends Node2D

signal weaponTimeout

const PROJECTILE = preload("res://gameObjects/player/projectile.tscn")

var canShoot = true

var attackInput = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$SFX/readySound.play()
	if get_parent():
		connect("weaponTimeout", Callable(get_parent(), "on_weaponTimeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attackInput.x = Input.get_action_strength("right_stick_right") - Input.get_action_strength("right_stick_left")
	attackInput.y = Input.get_action_strength("right_stick_down") - Input.get_action_strength("right_stick_up")
	if attackInput and not $SFX/shootSound.is_playing():
		$SFX/shootSound.play()
	if attackInput == Vector2.ZERO:
		$SFX/shootSound.stop()

func fire(attackInput):
#	$AnimatedSprite2D.play("shoot")
	if canShoot:
#		if !$SFX/shootSound.is_playing():
#			$SFX/shootSound.play()
		var p = PROJECTILE.instantiate()
		p.scale *= 2
		p.position = global_position
		p.rotation = attackInput.angle()
		p.moveVector = attackInput.normalized()
		get_tree().get_root().add_child(p)


func _on_timer_timeout():
	emit_signal("weaponTimeout")
