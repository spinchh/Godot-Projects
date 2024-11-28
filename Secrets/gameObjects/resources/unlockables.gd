extends Resource

var items = {
	"PISTOL" = {
		ID = 0,
		Name = "PISTOL",
		inputCode = [],
		imageRef = "res://art/Custom/pistol.png",
		timeOut = 0,
		cooldown = 0,
		isUnlocked = false,
	},
	"RIFLE" = {
		ID = 1,
		Name = "RIFLE",
		inputCode = [1, 2, 3, 3],
		imageRef = "res://art/Custom/rifle.png",
		timeOut = 15,
		cooldown = 10,
		isUnlocked = false,
	},
	"MACE" = {
		ID = 2,
		Name = "MACE",
		inputCode = [3, 4, 1, 4, 3],
		imageRef = "res://art/Custom/mace.png",
		timeOut = 10,
		cooldown = 10,
		isUnlocked = false,
	},
	"ROCKET" = {
		ID = 3,
		Name = "ROCKET",
		inputCode = [3, 1, 2, 2, 4],
		imageRef = "res://art/Custom/launcher.png",
		timeOut = 7,
		cooldown = 20,
		isUnlocked = false,
	},
	"BEAM" = {
		ID = 4,
		Name = "BEAM",
		inputCode = [4, 3, 2, 1, 4, 3, 3],
		imageRef = "res://art/Custom/omegabeam.png",
		timeOut = 5,
		cooldown = 30,
		isUnlocked = false,
	},
	"SHOTGUN" = {
		ID = 5,
		Name = "SHOTGUN",
		inputCode = [3, 3, 1, 4, 2],
		imageRef = "res://art/Custom/shotgun.png",
		timeOut = 12,
		cooldown = 10,
		isUnlocked = false
	}
}

var upgrades = {
	"SHIELD1" = {
		ID = 0,
		inputCode = [3, 3, 2],
		isUnlocked = false,
		itemType = "SHIELD"
	},
	"SHIELD2" = {
		ID = 1,
		inputCode = [4, 3, 4, 3, 2],
		isUnlocked = false,
		itemType = "SHIELD"
	},
	"SHIELD3" = {
		ID = 2,
		inputCode = [1, 1, 4, 2, 3],
		isUnlocked = false,
		itemType = "SHIELD"
	},
	"REPAIRKIT" = {
		ID = 3,
		inputCode = [4, 1, 1],
		isUnlocked = false,
		itemType = "REPAIR" 
	}
}
