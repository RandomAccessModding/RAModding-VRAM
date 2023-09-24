extends "res://Scripts/Hosts/ShotgunBot/ShotgunBot.gd"

@onready var SkinManager = $"/root/ModLoader/RAModding-VRAM/SkinManager"

@onready var AnimationManager = get_node("/root/ModLoader/RAModding-VRAM/AnimationManager")

# I dislike this immensely
# TODO apply to all bots
func _ready():
	super._ready()
	for animation in AnimationManager.animations[Enemy.EnemyType.SHOTGUN].keys():
		animplayer.add_animation_library(animation, AnimationManager.animations[Enemy.EnemyType.SHOTGUN][animation]["animation_library"])

func handle_skin():
	if not upgrades.is_empty():
		for upgrade in upgrades.keys():
			if upgrade in SkinManager.upgrade_skins[Enemy.EnemyType.SHOTGUN]:
				var _shotgun_skins = SkinManager.bot_skins[Enemy.EnemyType.SHOTGUN]
				var skin = SkinManager.upgrade_skins[Enemy.EnemyType.SHOTGUN][upgrade]
				sprite.texture = load(_shotgun_skins[skin]["sprite_sheet_path"])
				break
	elif is_player:
		var _shotgun_skins = SkinManager.bot_skins[Enemy.EnemyType.SHOTGUN]
		var skin = SkinManager.player_skins[Enemy.EnemyType.SHOTGUN] 
		if skin in _shotgun_skins:
			sprite.texture = load(_shotgun_skins[skin]["sprite_sheet_path"])
