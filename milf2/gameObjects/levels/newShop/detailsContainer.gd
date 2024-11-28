extends VBoxContainer

@onready var imageCont = $imageContainer/PanelContainer/MarginContainer/TextureRect
@onready var descCont = $descContainer/PanelContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("detailsContainer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateDetails(imagePath, desc):
	var newImage = load(imagePath)
	imageCont.texture = newImage
	descCont.text = desc
	
