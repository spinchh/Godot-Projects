extends Enemy

#state machine variables
enum STATES {MOVING, SHOOTING}
var state = STATES.MOVING

#handles firing time for projectiles
var shotCount = 3
var shotsFired = 0
var canShoot = true

const SPEED = 90
const PROJECTILE = preload("res://gameObjects/enemies/enemyProjectiles/enemyProjectile.tscn")

#assign Navigation Agent node as navAgent
@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	#add self to enemies group
	self.add_to_group("enemies")

func _physics_process(delta):
	#if not dead and if a target is assigned
	if active:
		if player:
			match state:
				STATES.MOVING:
					#grab direction to next pathfinding target and move towards it
					var navDir = to_local(navAgent.get_next_path_position()).normalized()
					velocity = navDir * SPEED
					
					#grab player position and rotate the raycast towards it
					var shotDir = (global_position - player.global_position).normalized()
					$RayCast2D.target_position = shotDir * -100
					
					#Shoot projectile, if able
					if $RayCast2D.is_colliding() and canShoot:
						fireProjectile(shotDir)
				STATES.SHOOTING:
					#lock position in place
					velocity = Vector2.ZERO
					
					#grab player position and rotate the raycast towards it
					var shotDir = (global_position - player.global_position).normalized()
					$RayCast2D.target_position = shotDir * -100
					if canShoot:
						fireProjectile(shotDir)
		move_and_slide()

func fireProjectile(shotDir):
	#set state machine to shooting
	state = STATES.SHOOTING
	#add shots to shot count
	shotsFired += 1
	#adds delay between shots
	canShoot = false
	#create projectile, give it direction and rotation, and send it
	var p = PROJECTILE.instantiate()
	p.position = self.position
	p.rotation = shotDir.angle()
	p.moveVector = -shotDir.normalized()
	get_tree().get_root().add_child(p)
	#chase the player after firing three shots
	if shotsFired >= shotCount:
		shotCooldown()
	$shotTimer.start()

func newPath():
	if player:
		navAgent.set_target_position(player.global_position)

func shotCooldown():
	$RayCast2D.set_collision_mask_value(1, false)
	$cooldownTimer.start()
	shotsFired = 0
	state = STATES.MOVING

func _on_timer_timeout():
	newPath()

func _on_shot_timer_timeout():
	canShoot = true

func _on_cooldown_timer_timeout():
	$RayCast2D.set_collision_mask_value(1, true)
