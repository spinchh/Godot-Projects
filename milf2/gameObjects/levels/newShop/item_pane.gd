extends BoxContainer

signal activeItem

var itemName = null
var itemImageRef = null
var itemID = null
var itemDesc = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if itemName:
		$mainCont/labelMarginCont/Label.text = itemName
	if itemImageRef:
		var texture = load(itemImageRef)
		$mainCont/itemArtCont/TextureRect.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	get_tree().call_group("detailsContainer", "updateDetails", itemImageRef, itemDesc)
