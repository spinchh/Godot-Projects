extends Node2D


func _ready():
	if PlayerVariables.bosses['lavaSlime'] == true:
		get_node("lavaSlime").queue_free()
	
	if PlayerVariables.bosses['kingSlime'] == true:
		get_node("slimeKing").queue_free()
