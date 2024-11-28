extends Enemy

const SPEED = 120

@onready var navAgent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	health = 20
	$AnimatedSprite2D.play("idle")
	self.add_to_group("enemies")

func _physics_process(delta):
	if active:
		if player:
			$AnimatedSprite2D.play("walk")
			var dir = to_local(navAgent.get_next_path_position()).normalized()
			velocity = dir * SPEED
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			if $AnimatedSprite2D.animation == "walk" and ($AnimatedSprite2D.frame == 1 or $AnimatedSprite2D.frame == 3) and !$SFX/footstepSound.is_playing():
					$SFX/footstepSound.play()
		move_and_slide()

func newPath():
	if player:
		navAgent.target_position = player.global_position

func _on_timer_timeout():
	newPath()

func _on_attack_box_body_entered(body):
	body.takeDamage()
