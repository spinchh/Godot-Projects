extends Node2D

onready var tween = get_node("tweenOut")
onready var tween1 = get_node("tweenIn")
onready var overworld = get_node("musicOverworld")
onready var cave = get_node("musicCave")
onready var lavaSlime = get_node("musicLavaSlime")
onready var kingSlime = get_node("musicKingSlime")

onready var currentMusic = overworld

var defaultVolume = -10
var silence = -80
var transitionDuration = 1
var transitionType = 1


func _ready():
	fadeIn()

func switchMusic():
	fadeOut()
	
	yield(get_tree().create_timer(1), "timeout")
	
	if currentMusic == overworld:
		currentMusic = cave
	else:
		currentMusic = overworld
	
	fadeIn()
	print(currentMusic)
	

func fadeOut():
	tween.interpolate_property(currentMusic, "volume_db", defaultVolume, silence, transitionDuration, transitionType, tween.EASE_IN, 0)
	tween.start()

func fadeIn():
	tween1.interpolate_property(currentMusic, "volume_db", silence, defaultVolume, transitionDuration, transitionType, tween1.EASE_IN, 0)
	tween1.start()

#king slime
func _on_AI_trigger_body_entered(body):
	fadeOut()
	yield(get_tree().create_timer(1), "timeout")
	currentMusic = kingSlime
	fadeIn()

func _on_musicTriggers_body_entered(body):
	switchMusic()


func _on_tweenOut_tween_completed(object, key):
	print('tween stop')
	object.stop()

func _on_tweenIn_tween_started(object, key):
	object.play()

#lava slime
func _on_AI_trigger1_body_entered(body):
	fadeOut()
	currentMusic = lavaSlime
	currentMusic.play()

func _on_lavaSlime_spawnItemDrop():
	fadeOut()
