extends GridContainer

const ITEMPANE = preload("res://gameObjects/levels/newShop/item_pane.tscn")

#Resource files for various shop categories
@onready var rodsData = load("res://resources/shopItems/rods.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rodsDataCount = rodsData.rodData.size()
	for i in rodsDataCount:
		var itemData = rodsData.rodData["rod" + str(i)]
		var p = ITEMPANE.instantiate()
		p.itemName = itemData.Name
		p.itemImageRef = itemData.ImageRef
		p.itemDesc = itemData.Description
		p.itemID = itemData.ID
		
		add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
