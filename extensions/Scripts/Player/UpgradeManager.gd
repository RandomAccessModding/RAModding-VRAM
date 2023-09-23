extends "res://Scripts/Player/UpgradeManager.gd"

static var UpgradesHelper

static func get_all_upgrades_for_enemy_type(type : Enemy.EnemyType):
	if UpgradesHelper == null: UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"
	var upgrade_pool = UpgradesHelper.get_all_upgrade_ids().filter(func(upgrade): UpgradesHelper.get_upgrade(upgrade)['type'] == type).map(func(upgrade): return UpgradesHelper.get_upgrade(upgrade))
#	for upgrade in Upgrades.upgrades.keys():
#		if Upgrades.upgrades[upgrade]['type'] == type:
#			upgrade_pool.append(upgrade)
	return upgrade_pool
	
static func get_all_AI_upgrades_for_enemy_type(type : Enemy.EnemyType):
	if UpgradesHelper == null: UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"
	var upgrade_pool = []
	for upgrade in UpgradesHelper.get_all_upgrade_ids():
		if UpgradesHelper.get_upgrade(upgrade)['type'] == type and UpgradesHelper.get_upgrade(upgrade)['ai_useable'] == true:
			upgrade_pool.append(upgrade)
	return upgrade_pool

func get_random_upgrade(allowed_types = valid_enemy_types.duplicate(), excluded = [], tier = -1):
	if UpgradesHelper == null: UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"
	var new_upgrade = upgrade_scene.instantiate()
	
	var type
	if allowed_types is int:
		type = allowed_types
	else:
		type = allowed_types.pick_random()
		
	if tier < 0:
		tier = Util.choose_weighted([0, 1, 2], tier_weights)
	
	var upgrade_pool = get_all_upgrades_for_enemy_type(type)
	
	var invalid = []
	for i in range(upgrade_pool.size()):
		var upgrade_name = upgrade_pool[i]
		var upgrade_count = GameManager.player.upgrades[upgrade_name]
		var upgrade = UpgradesHelper.get_upgrade(upgrade_name)
		
		if upgrade_count > 0 and 'precludes' in upgrade:
			for precluded in upgrade['precludes']:
				invalid.append(precluded)
		
		if upgrade_name in excluded:
			invalid.append(upgrade_name)
			
		elif upgrade_count >= upgrade['max_stack']:
			invalid.append(upgrade_name)
		
		elif upgrade['tier'] != tier:
			invalid.append(upgrade_name)
	
	for invalid_upgrade in invalid:
		upgrade_pool.erase(invalid_upgrade)
		
	if upgrade_pool.is_empty():
		# First try finding an upgrade for the same enemy type at a lower tier
		if tier > 0:
			return get_random_upgrade(type, excluded, tier - 1) 
			
		# If the above doesn't work, find an upgrade for a different, random enemy type
		else:
			if allowed_types is int:
				allowed_types = valid_enemy_types.duplicate()
			
			allowed_types.erase(type)
			if not allowed_types.is_empty():
				return get_random_upgrade(allowed_types, excluded)
			else:
				# If all else fails, return null
				return null
		
	var chosen_upgrade = upgrade_pool.pick_random()
	print("upgrade ", chosen_upgrade)
	return chosen_upgrade
	

func generate_valid_upgrade(upgrade_array, tier = -1):
	if UpgradesHelper == null: UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"
	if tier == -1:
		tier = get_item_rarity()
	var upgrade_pool = []
	while upgrade_pool.is_empty():
		for upgrade in UpgradesHelper.get_all_upgrade_ids():
			if UpgradesHelper.get_upgrade(upgrade)['type'] in Enemy.PlayableEnemyType:
				upgrade_pool.append(upgrade)
				
		for upgrade in upgrade_pool:
			#Remove upgrades that are already in the selection
			if upgrade_array.has(upgrade):
				upgrade_pool.erase(upgrade)
				continue
				
			#Remove upgrades that the player already has capped
			if GameManager.player.upgrades[upgrade] >= UpgradesHelper.get_upgrade(upgrade)['max_stack']:
				upgrade_pool.erase(upgrade)
				continue
				
			#Remove any upgrades that are procluded by one the player already has
			if UpgradesHelper.get_upgrade(upgrade).has('precludes'):
				for precluded in UpgradesHelper.get_upgrade(upgrade)['precludes']:
					if GameManager.player.upgrades[precluded] > 0:
						upgrade_pool.erase(upgrade)
						continue
			
			#Remove any upgrades that are lower than the requested tier
			if tier != -1:
				if UpgradesHelper.get_upgrade(upgrade)['tier'] < tier:
					upgrade_pool.erase(upgrade)
					continue
			
		if upgrade_pool.is_empty():
			if tier > 0:
				tier = tier - 1
			else:
				print("NO VALID ITEM")
				return
	if not upgrade_pool.is_empty():
		var upgrade = upgrade_pool[int(randf()*len(upgrade_pool))]
		return upgrade
	return


func generate_valid_upgrade_new(upgrade_array, enemy_type = Enemy.EnemyType.UNKNOWN, tier = -1):
	if UpgradesHelper == null: UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"
	if tier == -1:
		tier = get_item_rarity()
	var upgrade_pool = []
	while upgrade_pool.is_empty():
		for upgrade in UpgradesHelper.get_all_upgrade_ids():
			if UpgradesHelper.get_upgrade(upgrade)['type'] not in Enemy.PlayableEnemyType:
				continue
			
			if not enemy_type == Enemy.EnemyType.UNKNOWN:
				if UpgradesHelper.get_upgrade(upgrade)['type'] != enemy_type:
					continue
				
			#Remove upgrades that are already in the selection
			if upgrade_array.has(upgrade):
				continue
				
			#Remove upgrades that the player already has capped
			if GameManager.player.upgrades[upgrade] >= UpgradesHelper.get_upgrade(upgrade)['max_stack']:
				continue
				
			#Remove any upgrades that are procluded by one the player already has
			if UpgradesHelper.get_upgrade(upgrade).has('precludes'):
				var precluded = false
				for precluded_upgrade in UpgradesHelper.get_upgrade(upgrade)['precludes']:
					if GameManager.player.upgrades[precluded_upgrade] > 0:
						precluded = true
				if precluded:
					continue
					
			
			#Remove any upgrades that are lower than the requested tier
			if tier != -1:
				if UpgradesHelper.get_upgrade(upgrade)['tier'] < tier:
					continue
			upgrade_pool.append(upgrade)
			
		if upgrade_pool.is_empty():
			if tier > 0:
				tier = tier - 1
			else:
				print("NO VALID ITEM")
				return
	if not upgrade_pool.is_empty():
		var upgrade = upgrade_pool[int(randf()*len(upgrade_pool))]
		return upgrade
	return
