extends TabContainer

#variables for storing shop data to be pulled in by the sub-menus
var rodData = null
# Called when the node enters the scene tree for the first time.
func _ready():
	rodData = load('res://resources/shopItems/rods.tres')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
