extends "res://Scripts/Hosts/FlameBot/FlameBot.gd"

@onready var SkinManager = $"/root/ModLoader/RAModding-VRAM/SkinManager"

func handle_skin():
	if not upgrades.is_empty():
		for upgrade in upgrades.keys():
			if upgrade in SkinManager.upgrade_skins[Enemy.EnemyType.FLAME]:
				var _flame_skins = SkinManager.bot_skins[Enemy.EnemyType.FLAME]
				var skin = SkinManager.upgrade_skins[Enemy.EnemyType.FLAME][upgrade]
				sprite.texture = load(_flame_skins[skin]["sprite_sheet_path"])
				nozzle_sprite.texture = load(_flame_skins[skin]["extra_sprites"]["nozzle"])
				break
	elif is_player:
		var _flame_skins = SkinManager.bot_skins[Enemy.EnemyType.FLAME]
		var skin = SkinManager.player_skins[Enemy.EnemyType.FLAME] 
		if skin in _flame_skins:
			sprite.texture = load(_flame_skins[skin]["sprite_sheet_path"])
			nozzle_sprite.texture = load(_flame_skins[skin]["extra_sprites"]["nozzle"])
