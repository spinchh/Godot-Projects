extends Area2D

signal purchasedItem

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.get("coins") >= 50:
		emit_signal("purchasedItem")
		$pickaxe.visible = false
		
	else:
		print("come back with some money, buddy")
