extends "res://Scripts/Hosts/WheelBot/WheelBot.gd"

@onready var SkinManager = $"/root/ModLoader/RAModding-VRAM/SkinManager"

func handle_skin():
	if not upgrades.is_empty():
		for upgrade in upgrades.keys():
			if upgrade in SkinManager.upgrade_skins[Enemy.EnemyType.WHEEL]:
				var _wheel_skins = SkinManager.bot_skins[Enemy.EnemyType.WHEEL]
				var skin = SkinManager.upgrade_skins[Enemy.EnemyType.WHEEL][upgrade]
				sprite.texture = load(_wheel_skins[skin]["sprite_sheet_path"])
				break
	elif is_player:
		var _wheel_skins = SkinManager.bot_skins[Enemy.EnemyType.WHEEL]
		var skin = SkinManager.player_skins[Enemy.EnemyType.WHEEL] 
		if skin in _wheel_skins:
			sprite.texture = load(_wheel_skins[skin]["sprite_sheet_path"])
