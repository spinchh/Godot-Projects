extends Node2D
#this script should contain all logic for handling weapons.

signal weaponChanged

#weapons list. 
enum WEAPONS {PISTOL, MACE, RIFLE, ROCKET}
var currentWeapon = WEAPONS.PISTOL
var currentWeaponID

#preloaded weapon scenes
const PISTOL = preload("res://gameObjects/player/playerWeapons/pistol/pistol.tscn")
const RIFLE = preload("res://gameObjects/player/playerWeapons/rifle/rifle.tscn")
const MACE = preload("res://gameObjects/player/playerWeapons/mace/mace.tscn")
const ROCKET = preload("res://gameObjects/player/playerWeapons/launcher/launcher.tscn")
const BEAM = preload("res://gameObjects/player/playerWeapons/omegaBeam/omegaBeam.tscn")
const SHOTGUN = preload("res://gameObjects/player/playerWeapons/shotgun/shotgun.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#equip pistol by default
	var initWeapon = PISTOL.instantiate()
	add_child(initWeapon)
	currentWeapon = initWeapon

func swapWeapon(newWeapon):
	#match weapon dictionary value to preloaded scenes via ID
	get_tree().call_group("weaponUI", "weaponTimeout", currentWeaponID)
	var weapon = null
	match newWeapon.ID:
		0:
			weapon = PISTOL
			currentWeaponID = 0
		1:
			weapon = RIFLE
			currentWeaponID = 1
		2:
			weapon = MACE
			currentWeaponID = 2
		3:
			weapon = ROCKET
			currentWeaponID = 3
		4:
			weapon = BEAM
			currentWeaponID = 4
		5: 
			weapon = SHOTGUN
			currentWeaponID = 5
	#skip if current weapon is selected. Otherwise, delete old weapon and equip new one
	get_tree().call_group("weaponUI", "weaponUnlocked", currentWeaponID)
	if weapon == currentWeapon or weapon == null:
		return
	else:
		currentWeapon.queue_free()
		currentWeapon = weapon.instantiate()
		add_child(currentWeapon)
	
#called by player node in the SHOOTING state
func fireCurrentWeapon(attackInput):
	currentWeapon.fire(attackInput)

func on_weaponTimeout():
	get_tree().call_group("weaponUI", "weaponTimeout", currentWeaponID)
	currentWeapon.queue_free()
	currentWeapon = PISTOL.instantiate()
	add_child(currentWeapon)

func flipSprite(value: bool):
	var spriteNode = get_child(0).get_node("Sprite2D")
	if spriteNode and !get_child(0).has_method("_on_swing_timer_timeout"):
		spriteNode.flip_h = value
	
