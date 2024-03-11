extends CanvasLayer

signal coinCollect

var coins = PlayerVariables.dataDictionary['coins']
var mushrooms = PlayerVariables.dataDictionary['mushrooms'].size()

func _ready():
	mushrooms = PlayerVariables.dataDictionary['mushrooms'].size()
	$"coin counter/coinCount".text = String(coins)
	$"mushroom counter/Label2".text = String(mushrooms)

func _on_coinCollected():
	coins = coins + 1
	emit_signal("coinCollect")
	_ready()

func _on_pickaxeMan_purchasedItem():
	coins = coins - 50
	_ready()

func _on_mushroom_mushroomCollected():
	_ready()

func _on_mushroomSlime_mushroomPurchase():
	_ready()
