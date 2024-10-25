extends GridContainer

const ITEMPANE = preload("res://gameObjects/levels/newShop/item_pane.tscn")

#Resource files for various shop categories
@onready var rodsData = load("res://resources/shopItems/rods.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	var rodsDataCount = rodsData.rodData.size()
	for i in rodsDataCount:
		var p = ITEMPANE.instantiate()
		add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
