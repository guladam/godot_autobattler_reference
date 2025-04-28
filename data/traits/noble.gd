extends TraitBonus


func apply_bonus() -> void:
	for unit: BattleUnit in get_tree().get_nodes_in_group("player_units"):
		unit.tree_exited.connect(_on_player_unit_died.bind(unit), CONNECT_ONE_SHOT)
	
	_check_for_activation()


func _on_player_unit_died(unit: BattleUnit) -> void:
	if not unit.is_queued_for_deletion():
		return
		
	_check_for_activation()
	

func _check_for_activation() -> void:
	var remaining_units := get_tree().get_nodes_in_group("player_units")
	if remaining_units.is_empty():
		return
	
	var first_unit: BattleUnit = remaining_units[0]
	if remaining_units.size() == 1 and first_unit.stats.traits.has(trait_data):
		var modifier_ad := first_unit.modifier_handler.get_modifier(Modifier.Type.UNIT_AD)
		var modifier_atk_sp := first_unit.modifier_handler.get_modifier(Modifier.Type.UNIT_ATKSPEED)
		var flat_ad := ModifierValue.create_new_modifier("noble_trait", ModifierValue.Type.FLAT)
		flat_ad.flat_value = 10
		var percent_atk_speed := ModifierValue.create_new_modifier("noble_trait", ModifierValue.Type.PERCENT_BASED)
		percent_atk_speed.percent_value = -0.25
		modifier_ad.add_new_value(flat_ad)
		modifier_atk_sp.add_new_value(percent_atk_speed)
		first_unit.stats.health += 50
