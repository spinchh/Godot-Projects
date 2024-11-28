extends Enemy

const SPEED = 90

@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	health = 1
	$AnimatedSprite2D.play("default")
	self.add_to_group("enemies")

func _physics_process(delta):
	if active:
		if player:
			if !$SFX/idleSound.is_playing():
				$SFX/idleSound.play()
			var dir = to_local(navAgent.get_next_path_position()).normalized()
			velocity = dir * SPEED
		move_and_slide()

func newPath():
	if player:
		navAgent.target_position = player.global_position

func _on_timer_timeout():
	newPath()

func _on_attack_box_body_entered(body):
	body.takeDamage()
