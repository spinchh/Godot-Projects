extends Node

@onready var moneyNode = $"dolla bills yall/money"

# Called when the node enters the scene tree for the first time.
func _ready():
	updateHUD()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateHUD():
	moneyNode.text = str(PlayerData.playerValues["money"])

func _on_player_update_hud():
	updateHUD()
