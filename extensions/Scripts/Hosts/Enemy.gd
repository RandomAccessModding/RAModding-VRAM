extends "res://Scripts/Hosts/Enemy.gd"
# A lot of these functions basically had to be ripped out and replaced with modded-compliant versions

@onready var UpgradesHelper = $"/root/ModLoader/RAModding-VRAM/UpgradesHelper"

func apply_enemy_modifications():
	for upgrade in starting_conditions.upgrades:
		if upgrade not in UpgradesHelper._mod_upgrades: continue
		if upgrade in upgrades:
			upgrades[upgrade] += 1
		else:
			upgrades[upgrade] = 1

func calculate_score_value():
	var score_mult = 1.0
	score_mult += max_swap_shield_health/max_health
	if is_instance_valid(AI):
		score_mult += 0.25*AI.AI_level
	for upgrade in upgrades.keys():
		score_mult += 0.1*upgrades[upgrade]*(UpgradesHelper.get_upgrade(upgrade).tier + 1)
		
	if starting_conditions.is_elite:
		score_mult = max(score_mult, 1.5)
	
	score = Util.round_to_nearest(Fitness.enemy_score_values[enemy_type]*score_mult, 10)

func get_currently_applicable_upgrades():
	var to_apply = super.get_currently_applicable_upgrades()
	for upgrade in UpgradesHelper._mod_upgrades.keys():
		if UpgradesHelper._mod_upgrades[upgrade].type == enemy_type or UpgradesHelper._mod_upgrades[upgrade].type == EnemyType.UNKNOWN:
			to_apply[upgrade] = 0
			
			if upgrade in upgrades:
				to_apply[upgrade] += upgrades[upgrade]
				
			if is_player and upgrade in GameManager.player.upgrades:
				to_apply[upgrade] += GameManager.player.upgrades[upgrade]
				
	return to_apply
	
