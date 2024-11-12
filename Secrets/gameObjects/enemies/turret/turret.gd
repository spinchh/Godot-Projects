extends Enemy

const PROJECTILE = preload("res://gameObjects/enemies/enemyProjectiles/enemyProjectile.tscn")

var canShoot = true

func _physics_process(delta):
	if active:
		if player:
			var direction = (global_position - player.global_position).normalized()
			$playerRayCast.target_position = direction * -100
			if $playerRayCast.is_colliding() and canShoot:
				fireProjectile(direction)

func fireProjectile(direction):
	canShoot = false
	var p = PROJECTILE.instantiate()
	p.position = self.position
	p.rotation = direction.angle()
	p.moveVector = -direction.normalized()
	get_tree().get_root().add_child(p)
	$Timer.start()


func _on_timer_timeout():
	canShoot = true
