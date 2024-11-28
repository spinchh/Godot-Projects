extends Enemy

const PROJECTILE = preload("res://gameObjects/enemies/enemyProjectiles/enemyProjectile.tscn")

var canShoot = true

func _ready():
	health = 10

func _physics_process(delta):
	if active:
		if player:
			var direction = (global_position - player.global_position).normalized()
			$playerRayCast.target_position = direction * -100
			if $playerRayCast.is_colliding() and canShoot:
				var collider = $playerRayCast.get_collider()
				if collider and collider.is_in_group("player"):
					fireProjectile(direction)

func fireProjectile(direction):
	$SFX/shootSound.play()
	canShoot = false
	var p = PROJECTILE.instantiate()
	p.position = self.position
	p.rotation = direction.angle()
	p.moveVector = -direction.normalized()
	p.makeBlank()
	get_tree().get_root().add_child(p)
	$Timer.start()


func _on_timer_timeout():
	canShoot = true
