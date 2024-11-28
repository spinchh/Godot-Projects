extends Control

@export var player = Node2D

@onready var shieldRect = preload("res://gameObjects/UI/shieldRect.tscn")

var maxHealth = 3
var currentHealth = 3

var maxShields = 0
var currentShields = 0

var shieldActive = true

func _ready():
	if player:
		maxShields = PlayerData.playerData.maxShieldCount
		currentShields = maxShields
		maxHealth = player.maxPlayerHealth
		currentHealth = player.playerHealth
		for i in maxShields:
			var r = shieldRect.instantiate()
			$HBoxContainer.add_child(r)

# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass

func _on_player_damage_taken(healthRemaining):
	currentHealth = healthRemaining
	var percentLeft =  (float(currentHealth) / float(maxHealth)) * 100
	$Panel/TextureRect/TextureProgressBar.value = percentLeft


func _on_player_shield_broken():
	for child in $HBoxContainer.get_children():
		if !child.isActive:
			child.startTimer()
		else:
			child.shieldBroken()
			break
		

func _on_player_update_hud(updateType):
	match updateType:
		"SHIELD":
			for child in $HBoxContainer.get_children():
				child.queue_free()
			if player:
				maxShields = player.maxShieldCount
				currentShields = maxShields
				for i in maxShields:
					var r = shieldRect.instantiate()
					$HBoxContainer.add_child(r)
		"REPAIR":
				currentHealth = maxHealth
				var percentLeft =  (float(currentHealth) / float(maxHealth)) * 100
				$Panel/TextureRect/TextureProgressBar.value = percentLeft
