extends Area2D

const SLIME = preload("res://assets/scenes/enemySlime.tscn")

export var canDetectEdges = false
export var isBeefy = false
export var direction = 1


var isOnScreen = false
var childIsAlive = false

func _ready():
	$Sprite.visible = false
	call_deferred("spawnEnemy")

func spawnEnemy():
	if not childIsAlive:
		var s = SLIME.instance()
		s.detectEdge = canDetectEdges
		s.beefy = isBeefy
		s.direction = direction
		
		get_parent().add_child(s)
		
		s.position.y = position.y
		s.position.x = position.x
		s.connect("hasDied", self, "respawnEnemy")
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
