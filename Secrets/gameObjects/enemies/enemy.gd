extends CharacterBody2D

class_name Enemy

signal died

@export var player:Node2D

var rng = RandomNumberGenerator.new()

var health = 3
var active = true
# Called when the node enters the scene tree for the first time.
func _ready(): 
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setPlayer(body):
	var offset = rng.randf_range(0, 1)
	await get_tree().create_timer(offset).timeout
	player = body
	

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

func playerDied():
	player = null
