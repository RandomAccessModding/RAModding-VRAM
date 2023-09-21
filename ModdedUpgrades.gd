extends Node

static var mod_upgrades := {
	
}

# TODO Add icon support to register_upgrade
# TODO Add modded upgrade support to everywhere else

# Register an upgrade and icon with mod_upgrades. Returns true if an upgrade was overriden.
# Refer to res://Scripts/Upgrades.gd for what each field means.
# 'name' can be either a String or the dictionary that contains every field.
# 'icon' is a path to an upgrade icon.
static func register_upgrade(id: String, name, icon: String, desc: String = "", effects: Array = [], type: int = -1, tier: int = -1, max_stack: int = -1, ai_useable: bool = false) -> bool:
	var overriden : bool = mod_upgrades.has(id)
	if name is Dictionary:
		mod_upgrades[id] = name
	elif name is String:
		mod_upgrades[id] = { 
			'name': name,
			'desc': desc,
			'effects': effects,
			'type': type,
			'tier': tier,
			'max_stack': max_stack,
			'ai_useable': ai_useable
		}
	return overriden
