extends Node2D

signal weaponTimeout

var canShoot = true
var swingCount = 0

@onready var mainSwingShape = $mainSwingArea/CollisionShape2D
@onready var mainSwingSprite = $mainSwingArea/Sprite2D

@onready var finalSwingShape = $finalSwingArea/CollisionShape2D
@onready var finalSwingSprite = $finalSwingArea/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$SFX/readySound.play()
	if get_parent():
		connect("weaponTimeout", Callable(get_parent(), "on_weaponTimeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire(attackInput):
	attackInput.x *= -1
	rotation = -attackInput.angle()
	if canShoot:
#		if swingCount == 2:
#			toggleHitbox(finalSwingShape, finalSwingSprite)
#			await get_tree().create_timer(1).timeout
#			swingCount = 0
#			canShoot = true
#		else:
		$SFX/shootSound.play()
		mainSwingSprite.flip_h = !mainSwingSprite.flip_h
#		swingCount +=1
		toggleHitbox(mainSwingShape, mainSwingSprite)
		$swingTimer.start()

func toggleHitbox(hitbox, sprite):
		canShoot = false
		hitbox.disabled = false
		sprite.visible = true
		sprite.play("default")
		await sprite.animation_finished
		hitbox.disabled = true
		sprite.visible = false

func _on_swing_timer_timeout():
	canShoot = true

func _on_final_swing_area_body_entered(body):
	body.takeDamage()

func _on_main_swing_area_body_entered(body):
	body.takeDamage(3)


func _on_timeout_timer_timeout():
	emit_signal("weaponTimeout")
