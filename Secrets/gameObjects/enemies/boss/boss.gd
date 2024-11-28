extends Enemy

const ROCKET = preload("res://gameObjects/enemies/boss/enemy_rocket.tscn")
const PROJECTILE = preload("res://gameObjects/enemies/enemyProjectiles/enemyProjectile.tscn")

@onready var navAgent := $NavigationAgent2D as NavigationAgent2D
@onready var rng2 = RandomNumberGenerator.new()

const SPEED = 100

var lives = 3
var speedMultiplier = 1

#vars related to navigation
var movePoints : Array[Vector2]
var canMove = true
var moveTarget : int

#vars related to shooting
var shotDir = Vector2.ZERO

var megabeamProjectileCount = 100
var arcAngle = 120

func _ready():
	health = 120
	rng2.randomize()
	for child in $pointHolder.get_children():
		var pos = child.global_position
		movePoints.append(pos)
	newPath()

func _physics_process(delta):
	if active:
		if player:
			shotDir = (global_position - player.global_position).normalized()
			$playerRayCast.target_position = shotDir * -700
			if canMove:
				$stompBox/CollisionShape2D.disabled = false
				$AnimatedSprite2D.play("walk")
				var dir = to_local(navAgent.get_next_path_position()).normalized()
				velocity = dir * SPEED * speedMultiplier
				if velocity.x < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
				if $AnimatedSprite2D.animation == "walk" and ($AnimatedSprite2D.frame == 2 or $AnimatedSprite2D.frame == 6) and !$SFX/footstepSound.is_playing():
					$SFX/footstepSound.play()
			else:
				velocity = Vector2.ZERO
				$stompBox/CollisionShape2D.disabled = true
			move_and_slide()

func newPath():
	await get_tree().process_frame
	var movePointCount = movePoints.size()
	var randomInt = rng2.randi_range(0,movePointCount)
	if moveTarget != randomInt:
		moveTarget = randomInt
		navAgent.target_position = movePoints[randomInt-1]
	else:
		newPath()

func randomAttack():
	$Sprite2D.visible = true
	
	for f in speedMultiplier:
		var randomInt = rng2.randi_range(0,1)
		match randomInt:
			0:
				var missilesFired = 0
				while missilesFired < 5:
					if active:
						$AnimatedSprite2D.play("missile")
						$SFX/shootSound.play()
						missileAttack()
						missilesFired += 1
						await $AnimatedSprite2D.animation_finished
						if missilesFired == 5:
							newPath()
							canMove = true
							$Sprite2D.visible = false
					else:
						missilesFired = 5
			1:
				var x = 0
				while x < 3:
					if active:
						var baseAngle = shotDir.angle()
						var startAngle = baseAngle - deg_to_rad(arcAngle/2)
						var angleStep = deg_to_rad(arcAngle) / (megabeamProjectileCount - 1)
						
						for i in range(megabeamProjectileCount):
							var currentAngle = startAngle + (i * angleStep)
							var projectileDir = Vector2(cos(currentAngle), sin(currentAngle))
							megabeamAttack(projectileDir)
						x += 1
							
						if x == 3:
							newPath()
							canMove = true
							$Sprite2D.visible = false
						$SFX/laserSound.play()
						await get_tree().create_timer(2).timeout
					else:
						x = 5

func takeDamage(damage = 1):
	health = health - damage
	var mat = $AnimatedSprite2D.material
	if mat and mat is ShaderMaterial:
		$AnimatedSprite2D.material.set("shader_param/flash_white" , true)
		await get_tree().create_timer(.1).timeout
		$AnimatedSprite2D.material.set("shader_param/flash_white" , false)
	var hitSound = $SFX/hitSound
	if hitSound:
		hitSound.play()
	if health <= 0:
		lives -=1
		if lives <= 0:
			die()
		else:
			print(lives)
			health = 120
			speedMultiplier +=1

func die():
	var deathSound = $SFX/deathSound
	if deathSound:
		deathSound.play()
	emit_signal("died")
	active = false
	if self.has_node("CollisionShape2D"):
		$CollisionShape2D.queue_free()
	if self.has_node("attackBox"):
		$attackBox.queue_free()
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func missileAttack():
		var r = ROCKET.instantiate()
		r.position = self.position
		r.rotation = shotDir.angle()
		r.moveVector = -shotDir.normalized()
		get_tree().get_root().add_child(r)

func megabeamAttack(direction):
	var p = PROJECTILE.instantiate()
	p.position = self.position
	p.rotation = direction.angle()
	p.moveVector = -direction.normalized()
	get_tree().get_root().add_child(p)

func _on_timer_timeout():
	canMove = true
	newPath()

func _on_navigation_agent_2d_navigation_finished():
	canMove = false
	randomAttack()

func _on_stomp_box_body_entered(body):
	body.takeDamage()
