extends Area2D

export var areaColor = "blueLocks1"
export var keyNeeded = "Blue"

func _on_unlockArea_body_entered(body):	
	if body.get("keyArray").has(keyNeeded):
		get_tree().call_group(areaColor, "unlock")
		set_collision_mask_bit(0, false)
	else:
		print(body.get("keyArray"))
		print("unlock failed")
		
