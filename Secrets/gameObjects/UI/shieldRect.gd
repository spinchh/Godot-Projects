extends PanelContainer

@export var isActive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if $Panel2/shieldTimer.get_time_left() > 0:
			var shieldRechargePercent = 100 - ($Panel2/shieldTimer.get_time_left() / $Panel2/shieldTimer.get_wait_time() * 100)
			$Panel2/TextureProgressBar.value = shieldRechargePercent

func shieldBroken():
	isActive = false
	$Panel2/TextureProgressBar.value = 0
	$Panel2/shieldTimer.start()

func startTimer():
	$Panel2/TextureProgressBar.value = 0
	$Panel2/shieldTimer.start()

func _on_shield_timer_timeout():
	isActive = true
