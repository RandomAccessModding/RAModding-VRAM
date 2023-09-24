extends Node

static var _mod_upgrades := {
	
}

# TODO Add icon support to register_upgrade
# TODO Add modded upgrade support to everywhere else

# Register an upgrade and icon with mod_upgrades. Returns true if an upgrade was overriden.
# Refer to res://Scripts/Upgrades.gd for what each field means.
# 'name' can be either a String or the dictionary that contains every field.
# 'icon' is a path to an upgrade icon.
static func register_upgrade(id: String, name, icon: String = "", desc: String = "", effects: Array = [], type: Enemy.EnemyType = Enemy.EnemyType.UNKNOWN, tier: int = -1, max_stack: int = -1, precludes: Array = [], ai_useable: bool = false) -> bool:
	var overriden : bool = _mod_upgrades.has(id)
	if name is Dictionary:
		_mod_upgrades[id] = name
	elif name is String:
		_mod_upgrades[id] = { 
			'name': name,
			'desc': desc,
			'effects': effects,
			'type': type,
			'tier': tier,
			'max_stack': max_stack,
			'precludes': precludes,
			'ai_useable': ai_useable,
			'icon': icon
		}
	return overriden

# Returns a base-game or modded upgrade from id
# TODO find a better way to handle errors than returning an empty dict
static func get_upgrade(id: String) -> Dictionary:
	if id in Upgrades.upgrades:
		return Upgrades.upgrades[id]
	elif id in _mod_upgrades:
		return _mod_upgrades[id]
	return {}

# List all the keys of Upgrade.upgrades & _mod_upgrades
static func get_all_upgrade_ids() -> Array:
	var keys = Upgrades.upgrades.keys()
	keys.append_array(_mod_upgrades.keys())
	return keys
