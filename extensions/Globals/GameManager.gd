extends "res://Globals/GameManager.gd"

static var modded_enemy_scenes := {}

# Function for accessing EITHER enemy_scenes or modded_enemy_scenes
# Prefer to use this over direct access to either.
# TODO find something cleaner than returning null on error
static func get_enemy_scenes(enemy) -> PackedScene:
	if enemy_scenes.has(enemy):
		return enemy_scenes[enemy]
	elif modded_enemy_scenes.has(enemy):
		return modded_enemy_scenes[enemy]
	return null

# Overriding GameManager function to work with modded enemies
func spawn_enemy(type):
	ModLoaderLog.info("Spawning Enemy", "RAModding-VRAM:GameManager")
	var new_enemy = get_enemy_scenes(type).instantiate()
	new_enemy.add_to_group("enemy")
	var d = level_time/30.0*level["pace"] - 2
	if randf() < (d/(d+4.0)/2.0):
		new_enemy.add_swap_shield(randf()*d*5)
			
	enemy_count += 1
	hosts.append(new_enemy)
	return new_enemy
