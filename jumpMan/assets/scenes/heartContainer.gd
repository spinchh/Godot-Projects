extends HBoxContainer

var heartFull = preload("res://assets/HUD/heart pixel art/heart pixel art 32x32.png")
var heartHalf = preload("res://assets/HUD/heart pixel art/heart pixel art 32x32 _half.png")
var heartEmpty = preload("res://assets/HUD/heart pixel art/heart pixel art 32x32 _empty.png")
var health =  PlayerVariables.dataDictionary['maxHealth']

func _ready():
	health
	if health > 6:
		for i in health/4:
			addHealth()

func updateHealth(value):
	for i in get_child_count():
		if value > i*2 + 1:
			get_child(i).texture = heartFull
		elif value > i * 2:
			get_child(i).texture = heartHalf
		else:
			get_child(i).texture = heartEmpty

func addHealth():
	var newHeart = TextureRect.new()
	add_child(newHeart)
	updateHealth(health)
	print(health)

func _on_Player_damageTaken(health):
	updateHealth(health)

func _on_Player_addHealth(health):
	addHealth()
