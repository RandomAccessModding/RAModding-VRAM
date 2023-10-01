extends "res://Scripts/Hosts/ShotgunBot/ShotgunBot.gd"

@onready var SkinManager = $"/root/ModLoader/RAModding-VRAM/SkinManager"
@onready var AnimationManager = $"/root/ModLoader/RAModding-VRAM/AnimationManager"

# The skin the bot uses. useful 
var skin_id = 0
var loaded_skin


# I dislike this immensely
# TODO apply to all bots
func _ready():
	super._ready()
	print("Loading animations for Steeltoe!")
	for animation in AnimationManager.get_animations_for_bot(Enemy.EnemyType.SHOTGUN).keys():
		animplayer.add_animation_library(animation, AnimationManager.animations[Enemy.EnemyType.SHOTGUN][animation]["library"])

func handle_skin():
	if not upgrades.is_empty():
		for upgrade in upgrades.keys():
			if upgrade in SkinManager.upgrade_skins[Enemy.EnemyType.SHOTGUN]:
				var _shotgun_skins = SkinManager.bot_skins[Enemy.EnemyType.SHOTGUN]
				var _skin = SkinManager.upgrade_skins[Enemy.EnemyType.SHOTGUN][upgrade]
				skin_id = _skin
				loaded_skin = load(_shotgun_skins[_skin]["sprite_sheet_path"])
				sprite.texture = loaded_skin
				break
	elif is_player:
		var _shotgun_skins = SkinManager.bot_skins[Enemy.EnemyType.SHOTGUN]
		var _skin = SkinManager.player_skins[Enemy.EnemyType.SHOTGUN] 
		if _skin in _shotgun_skins:
			skin_id = _skin
			loaded_skin = load(_shotgun_skins[_skin]["sprite_sheet_path"])
			sprite.texture = loaded_skin
