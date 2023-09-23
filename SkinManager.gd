extends Node

static var bot_skins : Dictionary = {
	Enemy.EnemyType.SHOTGUN: {},
	Enemy.EnemyType.CHAIN: {},
	Enemy.EnemyType.FLAME: {},
	Enemy.EnemyType.WHEEL: {},
}

static var player_skins : Dictionary = {
	Enemy.EnemyType.SHOTGUN: 0,
	Enemy.EnemyType.CHAIN: 0,
	Enemy.EnemyType.FLAME: 0,
	Enemy.EnemyType.WHEEL: 0,
	}

# Upgrades -> Skins
# Base-game skins have numeric ids, modded ones should be strings
static var upgrade_skins : Dictionary = {
	Enemy.EnemyType.SHOTGUN: {
		"induction_barrel": 2,
		"soldering_fingers": 1,
		"reload_coroutine": 3,
	},
	Enemy.EnemyType.CHAIN: {
		"whiplash": 1,
		"hassotobi": 3,
		"yorikiri": 2,
	},
	Enemy.EnemyType.FLAME: {
		"aerated_fuel_tanks": 1,
		"distended_spigot": 3,
		"laminar_outflow": 2,
	},
	Enemy.EnemyType.WHEEL: {
		"careful_packing": 2,
		"bulk_delivery": 1,
		"self-preservation_override": 3
	},
}

# Putting all the base-game skins into the bot_skins dictionary
# Adds additional on sprites, too (i.e. deadlift arm, aphid nozzle.)
func _ready():
	await Progression.ready
	
	for i in range(Progression.steeltoe_skins.size()):
		bot_skins[Enemy.EnemyType.SHOTGUN][i] = Progression.steeltoe_skins[i]
		
	for i in range(Progression.deadlift_skins.size()):
		bot_skins[Enemy.EnemyType.CHAIN][i] = Progression.deadlift_skins[i]
		var skin_name = Progression.deadlift_skins[i]["name"]
		match skin_name:
			"Hypoxic":
				bot_skins[Enemy.EnemyType.CHAIN][i]["extra_sprites"] = {
					"arm": "res://Art/Characters/ChainbotRAM/reel 107x109 Blue.png"
				}
			"Plate":
				bot_skins[Enemy.EnemyType.CHAIN][i]["extra_sprites"] = {
					"arm": "res://Art/Characters/ChainbotRAM/reel 107x109 Grey.png"
				}
			"Olympia":
				bot_skins[Enemy.EnemyType.CHAIN][i]["extra_sprites"] = {
					"arm": "res://Art/Characters/ChainbotRAM/reel 107x109 Gold.png"
				}
			_:
				bot_skins[Enemy.EnemyType.CHAIN][i]["extra_sprites"] = {
					"arm": "res://Art/Characters/ChainbotRAM/reel 107x109.png"
				}
	
	for i in range(Progression.router_skins.size()):
		bot_skins[Enemy.EnemyType.WHEEL][i] = Progression.router_skins[i]
	
	for i in range(Progression.aphid_skins.size()):
		bot_skins[Enemy.EnemyType.FLAME][i] = Progression.aphid_skins[i]
		var skin_name = Progression.aphid_skins[i]["name"]
		match skin_name:
			"Magnesium":
				bot_skins[Enemy.EnemyType.FLAME][i]["extra_sprites"] = {
					"nozzle": "res://Art/Characters/FlamebotRAM/nozzle3.png"
				}
			"Carbon":
				bot_skins[Enemy.EnemyType.FLAME][i]["extra_sprites"] = {
					"nozzle": "res://Art/Characters/FlamebotRAM/nozzle4.png"
				}
			"Krypton":
				bot_skins[Enemy.EnemyType.FLAME][i]["extra_sprites"] = {
					"nozzle": "res://Art/Characters/FlamebotRAM/nozzle2.png"
				}
			_:
				bot_skins[Enemy.EnemyType.FLAME][i]["extra_sprites"] = {
					"nozzle": "res://Art/Characters/FlamebotRAM/nozzle.png"
				}

# Register a skin with a given bot
# TODO allow skins to be locked behind progression -- that means also making a save system
# If bot_id is an EnemyType, a basegame bot will be given the skin. If it's a String, a modded bot.
static func register_skin(bot_id, skin_id : String, skin_name : String, icon_path: String, spritesheet_path : String, unlocked_by_default: bool = true, unlock_requirement : String = "", flavour_text : String = "", extra_sprites : Dictionary = {}):
	bot_skins[bot_id][skin_id] = {
		"name": skin_name,
		"path": icon_path,
		"sprite_sheet_path": spritesheet_path,
		"extra_sprites": extra_sprites,
		"unlocked": unlocked_by_default,
		"unlock_requirements": unlock_requirement,
		"flavour_text": flavour_text
	}

# Make an enemy bot with a given upgrade take a certain skin
# upgrade_id is the id of the upgrade, skin_id that of the skin.
static func give_upgrade_skin(bot_type, upgrade_id : String, skin_id):
	upgrade_skins[bot_type][upgrade_id] = skin_id
