extends Area2D

const FLY = preload("res://assets/scenes/enemyFly.tscn")

export var isFastBoy = false
export var switchTime = 5
export var isFacingRight = true
export var willGoUpwardsFirst = true

var isOnScreen = false
var childIsAlive = false

func _ready():
	$Sprite.visible = false
	call_deferred("spawnEnemy")

func spawnEnemy():
	if not childIsAlive:
		var f = FLY.instance()
		f.fastBoy = isFastBoy
		f.switchTime = switchTime
		f.facingRight = isFacingRight
		f.goesUpwardsFirst = willGoUpwardsFirst
		
		get_parent().add_child(f)
		
		f.position.y = position.y
		f.position.x = position.x
		f.connect("hasDied", self, "respawnEnemy")
		
		childIsAlive = true
		$Timer.stop()
	else:
		pass

func respawnEnemy():
	if not isOnScreen:
		childIsAlive = false
		spawnEnemy()
	else:
		$Timer.start(10)

func _on_VisibilityNotifier2D_screen_entered():
	isOnScreen = true

func _on_VisibilityNotifier2D_screen_exited():
	isOnScreen = false

func _on_Timer_timeout():
	respawnEnemy()
