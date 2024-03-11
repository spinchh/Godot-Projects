extends Node2D


func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), .7)
