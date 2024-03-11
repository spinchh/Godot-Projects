extends KinematicBody2D

enum States {AIR, GROUND, DAMAGE}

signal damageTaken
signal addHealth
signal died

#constants
const SPEED = 300
const GRAVITY = 35
const JUMPFORCE = -1000
const FIREBALL = preload("res://assets/scenes/fireball.tscn")

#Basic shit
var state = States.AIR
var velocity = Vector2(0, 0)
var speedbonus = 200

var jumpCount = 0
var direction = -1

var playerValues = {
	"maxHealth" : 6,
	"posx" : 256,
	"posy" : 430,
	
	"hasSprint" : false,
	"hasDoubleJump" : false,
	"hasPickaxe" : false,
	"hasFireball" : false,
	
	"coins" : 0,
	"mushrooms" : [],
	"shipParts" : [],
	"keyArray" : []
	}

#Inventory Nonsense

var maxHealth = playerValues['maxHealth']

var sprint = playerValues['hasSprint']
var doubleJump = playerValues['hasDoubleJump']
var hasPickaxe = playerValues['hasPickaxe']
var hasFireball = playerValues['hasFireball']

var coins = playerValues['coins']
var mushrooms = playerValues['mushrooms']
var shipPartCount = playerValues['shipParts']
var keyArray = playerValues['keyArray']

var health = maxHealth

func _ready():
	
	loadPlayerData()
	
	position.x = playerValues['posx']
	position.y = playerValues['posy']
	
	if doubleJump == true:
		jumpCount = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://assets/scenes/Level 1.tscn")
	
	if Input.is_action_just_pressed("fire") and hasFireball:
		fireball()
	
	match state:
		States.AIR:
			if is_on_floor():
				state = States.GROUND
				continue
			$Sprite.play("air")
			
			if Input.is_action_just_pressed("jump") and jumpCount == 1:
				jump()
				jumpCount = 0
			
			if Input.is_action_pressed("moveLeft"):
				velocity.x = -SPEED - speedbonus
				$Sprite.flip_h = true
				direction = 1
			elif Input.is_action_pressed("moveRight"):
				velocity.x = SPEED + speedbonus
				$Sprite.flip_h = false
				direction = -1
			else:
				velocity.x = lerp(velocity.x, 0, 0.3)
			moveAndFall()
				
		States.GROUND:
			if not is_on_floor():
				coyoteTime()
				
			if doubleJump:
				jumpCount = 1
			
			if Input.is_action_pressed("sprint") and sprint:
				speedbonus = 200
				$Sprite.set_speed_scale(1.5)
			else:
				speedbonus = 0
				$Sprite.set_speed_scale(1)
				
			if Input.is_action_pressed("moveLeft"):
				velocity.x = -SPEED - speedbonus
				$Sprite.play("walk")
				$Sprite.flip_h = true
				direction = 1
			elif Input.is_action_pressed("moveRight"):
				velocity.x = SPEED + speedbonus
				$Sprite.play("walk")
				$Sprite.flip_h = false
				direction = -1
			elif Input.is_action_pressed("crouch"):
				$Sprite.play("crouch")
				$Sprite.position.y = 3
				velocity.x = lerp(velocity.x, 0, 0.3)
			else:
				velocity.x = lerp(velocity.x, 0, 0.3)
				$Sprite.position.y = 0
				$Sprite.play("idle")
				
			if Input.is_action_just_pressed("jump"):
				jump()
				
			moveAndFall()
			
		States.DAMAGE:
			$Sprite.play('air')
			set_modulate(Color(1, 1, 1, .5))
			moveAndFall()



func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	state = States.AIR

func moveAndFall():
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func addCoin():
	coins = coins + 1

func bounce():
	state = States.AIR
	velocity.y = -400
	if health < maxHealth:
		health = health + 1
		emit_signal("damageTaken", health)

func bossBounce(posx):
	velocity.y = -1000
	if position.x < posx:
		velocity.x = -3000
	elif position.x > posx:
		velocity.x = 3000

func jump():
	velocity.y = JUMPFORCE
	state = States.AIR
	$soundJump.play()

func knockback(var posx, var damage):
	$Timer.start(.5)
	
	state = States.DAMAGE
	
	velocity.y = JUMPFORCE * .5
	
	if position.x < posx:
		velocity.x = -250
	elif position.x > posx:
		velocity.x = 250
	
	Input.action_release("moveLeft")
	Input.action_release("moveRight")
	
	health = health - damage
	
	$soundDamage.play()
	
	emit_signal("damageTaken", health)
		
	if health <= 0:
		$soundDead.play()
		died()

func died():
	$AnimationPlayer.play("died")
	set_collision_layer_bit(0, false)
	emit_signal("died")
	yield(get_tree().create_timer(2), "timeout")
	$Sprite.visible = false
	

func _on_Timer_timeout():
	set_modulate(Color(1,1,1,1))
	state = States.AIR

func fireball():
	var f = FIREBALL.instance()
	f.direction = direction
	
	get_parent().add_child(f)
	
	f.position.y = position.y
	f.position.x = position.x
	$soundFireball.play()

func _on_keyCollected(keyColor):
	keyArray.append(keyColor)
	print(keyArray)

func itemCollected(item):
	if item == "sprint":
		sprint = true
	elif item == "doubleJump":
		doubleJump = true
	elif item == "fireBall":
		hasFireball = true
	elif item == "pickAxe":
		hasPickaxe = true

func _on_lava_body_entered(body):
	health = health - 1
	emit_signal("damageTaken", health)
	$soundDamage.play()
	
	if health <= 0:
		died()
		$soundDead.play()
		
	print("LAVA")
	velocity.y = -800
	set_modulate(Color(1, 1, 1, .5))
	$Timer.start(1)

func _on_HUD_coinCollect():
	coins = coins + 1

func addMushroom(mushroomNumber):
	mushrooms.append(mushroomNumber)

func _on_pickaxeMan_purchasedItem():
	coins = coins - 50

func addHealth():
	maxHealth = maxHealth + 2
	health = maxHealth
	emit_signal("addHealth", maxHealth)
	print(maxHealth)

func _on_camerazoom_screen_entered():
	$Camera2D.set_zoom(Vector2(2, 2))

func loadPlayerData():
	playerValues = PlayerVariables.dataDictionary
	
	maxHealth = playerValues['maxHealth']

	sprint = playerValues['hasSprint']
	doubleJump = playerValues['hasDoubleJump']
	hasPickaxe = playerValues['hasPickaxe']
	hasFireball = playerValues['hasFireball']

	coins = playerValues['coins']
	mushrooms = playerValues['mushrooms']
	shipPartCount = playerValues['shipParts']
	keyArray = playerValues['keyArray']

	health = maxHealth


func saveData():
	var saveDict = {
		"maxHealth" : maxHealth,
		"posx": position.x,
		"posy" : position.y,
		
		"hasSprint" : sprint,
		"hasDoubleJump" : doubleJump,
		"hasPickaxe" : hasPickaxe,
		"hasFireball" : hasFireball,
		
		"coins" : coins,
		"mushrooms" :  mushrooms,
		"shipParts" : shipPartCount,
		"keyArray" : keyArray
	}
	PlayerVariables.saveData(saveDict)
	print(saveDict)

func _on_checkPoint_saveGame():
	saveData()

func _on_water_body_entered(body):
	velocity.y = JUMPFORCE

func _on_launchPad_win():
	$Sprite.play("air")
	$AnimationPlayer.play('win')

func _on_slimeKing_dead():
	$playerCamera.make_current()
