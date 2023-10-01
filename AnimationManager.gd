extends Node

# spritesheet_id -> loaded spritesheet
static var spritesheets := {}

# bot_id -> animation_id -> {spritesheets: {}, library}
# for instance, animations[Enemy.EnemyTypes.SHOTGUN]["backflip"] = {spritesheets: {0: "extra_animations_steeltoe", extra_spritesheet_ids: {0: {}}}}
# then you get a loaded spritesheet from the spritesheets
# (this is abstracted away, obviously)
static var animations := {}

static var SkinManager

static func get_animations_for_bot(bot_id) -> Dictionary:
	if bot_id in animations:
		return animations[bot_id]
	return {}

static func register_spritesheet(spritesheet_id : String, spritesheet: Texture2D):
	spritesheets[spritesheet_id] = spritesheet

# Bring an animation library into the dictionary.
# animation_id is how you reference the animations when calling, for example "hammertime" would make every animation in the library "hammertime/whatever"
# spritesheet_id refers to the key of the main spritesheet to use
# h_frames, v_frames is the horizontal & vertical frames in the animation
# extra_spritesheet_ids refers to extra parts, i.e. Deadlift's grapple arm, formatted like {"spritesheet": x, "h_frames": n, "v_frames": m}
# skin is the id of the skin, for base-game bots the default is 0
static func register_animation_library(bot_id, animation_id : String, animation_library : AnimationLibrary, spritesheet_id : String, h_frames : int, v_frames : int, extra_spritesheet_ids : Dictionary = {}, skin = 0):
	if not bot_id in animations: animations[bot_id] = {}
	if not animation_id in animations[bot_id]: animations[bot_id][animation_id] = {}
	if not "spritesheets" in animations[bot_id][animation_id]: animations[bot_id][animation_id]["spritesheets"] = {}
	if not "extra_spritesheet_ids" in animations[bot_id][animation_id]: animations[bot_id][animation_id]["spritesheets"]["extra_spritesheet_ids"] = {}
	animations[bot_id][animation_id]["library"] = animation_library
	animations[bot_id][animation_id]["h_frames"] = h_frames
	animations[bot_id][animation_id]["v_frames"] = v_frames
	animations[bot_id][animation_id]["spritesheets"][skin] = spritesheet_id
	animations[bot_id][animation_id]["spritesheets"]["extra_spritesheet_ids"][skin] = extra_spritesheet_ids

# Add a skin to a given animation
# refer to register_animation_library
static func add_skin_to_animation(bot_id, animation_id : String, spritesheet_id : String, extra_spritesheet_ids : Dictionary = {}, skin = 0):
	if not bot_id in animations: animations[bot_id] = {}
	if not animation_id in animations[bot_id]: animations[bot_id][animation_id] = {}
	if not "spritesheets" in animations[bot_id][animation_id]: animations[bot_id][animation_id]["spritesheets"] = {}
	if not "extra_spritesheet_ids" in animations[bot_id][animation_id]: animations[bot_id][animation_id]["spritesheets"]["extra_spritesheet_ids"] = {}
	animations[bot_id][animation_id]["spritesheets"][skin] = spritesheet_id
	animations[bot_id][animation_id]["spritesheets"]["extra_spritesheet_ids"][skin] = extra_spritesheet_ids

# Play a custom animation on this bot.
# Usually, you'll pass in `self` for bot.
# Instead of "library/animation" you do "library", "animation".
static func play_animation(bot : Enemy, skin, library_id : String, animation_name : String):
	var new_sprite = spritesheets[animations[bot.enemy_type][library_id]["spritesheets"][skin]]
	var normal_hframes = bot.sprite.hframes
	var normal_vframes = bot.sprite.vframes
	bot.sprite.texture = new_sprite
	bot.sprite.frame = 0
	bot.sprite.hframes = animations[bot.enemy_type][library_id]["h_frames"]
	bot.sprite.vframes = animations[bot.enemy_type][library_id]["v_frames"]
	bot.play_animation(library_id + "/" + animation_name)
	await bot.animplayer.animation_finished
	bot.sprite.texture = bot.loaded_skin
	bot.sprite.hframes = normal_hframes
	bot.sprite.vframes = normal_vframes
	bot.play_animation("Idle")
