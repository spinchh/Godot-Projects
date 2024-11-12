extends CharacterBody2D

class_name Enemy

@export var player:Node2D

var health = 3
var active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func takeDamage():
	health = health - 1
	if health <= 0:
		active = false
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()

func playerDied():
	player = null
