extends Control

@onready var gearCont = $gearContainer
@onready var appCont = $apparelContainer
@onready var boatCont = $boatContainer
@onready var miscCont = $miscContainer

var activeCont = null

func _ready():
	activeCont = gearCont

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	activeCont.visible = true

func _on_gear_pressed():
	activeCont.visible = false
	activeCont = gearCont

func _on_apparel_pressed():
	activeCont.visible = false
	activeCont = appCont

func _on_boat_stuff_pressed():
	activeCont.visible = false
	activeCont = boatCont

func _on_misc_pressed():
	activeCont.visible = false
	activeCont = miscCont
