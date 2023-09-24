extends Node

# spritesheet_id -> loaded spritesheet
static var spritesheets := {}

# bot_id -> animation_id -> {spritesheet_id, animation_library}
# for instance, animations[Enemy.EnemyTypes.SHOTGUN]["backflip"] = {spritesheet: "extra_animations_steeltoe", extra_spritesheet_ids: {}}
# then you get a loaded spritesheet from the spritesheets
# (this is abstracted away, obviously)
static var animations := {}

static func play_animation(bot : Enemy, bot_id, animation_id : String):
	var bot_texture = bot.sprite.texture
	bot.sprite.texture = spritesheets[animations[bot_id][animation_id]["spritesheet_id"]]
	bot.play_animation(animation_id)
	await bot.anim_player.animation_finished
	bot.sprite.texture = bot_texture

static func register_spritesheet(spritesheet_id : String, spritesheet: Texture2D):
	spritesheets[spritesheet_id] = spritesheet

static func register_animation_library(bot_id, animation_id : String, animation_library : AnimationLibrary, spritesheet_id : String, extra_spritesheet_ids : Dictionary = {}):
	if not bot_id in animations: animations[bot_id] = {}
	animations[bot_id][animation_id] = {
		"spritesheet_id": spritesheet_id,
		"extra_spritesheet_ids": extra_spritesheet_ids,
		"animation_library": animation_library,
	}
