extends Node

var speedrunMode = false

var running = false
var elapsedTime = 0.0


var playerData = {
	maxShieldCount = 0,
	hasBeatenGame = true
}

var bossDoors = [false, false]

func addShields():
	playerData.maxShieldCount += 1

func _physics_process(delta):
	if speedrunMode and running:
		elapsedTime += delta

func restartTimer():
	elapsedTime = 0.0

func startTimer():
	running = true

func stopTimer():
	running = false
