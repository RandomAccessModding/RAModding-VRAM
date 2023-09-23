extends "res://Scripts/Player/Player.gd"

@onready var UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for upgrade in UpgradesHelper._mod_upgrades.keys():
		if not upgrade in upgrades:
			upgrades[upgrade] = 0
