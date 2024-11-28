extends Node

const MED = preload("res://gameObjects/levels/level_1.tscn")
const RND = preload("res://gameObjects/levels/level_3.tscn")
const MAIN = preload("res://gameObjects/levels/level_2.tscn")
# Called when the node enters the scene tree for the first time.

func changeScene(targetLevel):
	get_tree().change_scene_to_file(targetLevel)
