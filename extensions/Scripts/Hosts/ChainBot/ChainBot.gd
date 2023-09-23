extends "res://Scripts/Hosts/ChainBot/ChainBot.gd"

@onready var SkinManager = $"/root/ModLoader/RAModding-VRAM/SkinManager"

func _ready():
	super._ready()

func handle_skin():
	if not upgrades.is_empty():
		for upgrade in upgrades.keys():
			if upgrade in SkinManager.upgrade_skins[Enemy.EnemyType.CHAIN]:
				var _chain_skins = SkinManager.bot_skins[Enemy.EnemyType.CHAIN]
				var skin = SkinManager.upgrade_skins[Enemy.EnemyType.CHAIN][upgrade]
				sprite.texture = load(_chain_skins[skin]["sprite_sheet_path"])
				arm_sprite.texture = load(_chain_skins[skin]["extra_sprites"]["arm"])
				break
	elif is_player:
		var _chain_skins = SkinManager.bot_skins[Enemy.EnemyType.CHAIN]
		var skin = SkinManager.player_skins[Enemy.EnemyType.CHAIN] 
		if skin in _chain_skins:
			sprite.texture = load(_chain_skins[skin]["sprite_sheet_path"])
			arm_sprite.texture = load(_chain_skins[skin]["extra_sprites"]["arm"])
