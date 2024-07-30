class_name UnitCombiner
extends Node


func update_unit_combinations(_unit: Unit) -> void:
	var units := get_tree().get_nodes_in_group("units")
	
	for tier in [1, 2]:
		var tier_groups := _group_units_by_name_and_tier(units, tier)
		
		for unit_name in tier_groups:
			var current_units: Array = tier_groups[unit_name]
			while current_units.size() >= 3:
				print("combining 3 tier%s..." % tier)
				print(current_units)
				current_units[0].stats.tier += 1
				current_units[1].remove_from_group("units")
				current_units[2].remove_from_group("units")
				current_units[1].queue_free()
				current_units[2].queue_free()
				current_units = current_units.slice(3)
				print(current_units)


func _group_units_by_name_and_tier(units: Array[Node], tier: int) -> Dictionary:
	var filtered_units := units.filter(
		func(unit: Unit): 
			return unit.stats.tier == tier
	)
	var unit_counts := {}
	
	for unit: Unit in filtered_units:
		if unit_counts.has(unit.stats.name):
			unit_counts[unit.stats.name].append(unit)
		else:
			unit_counts[unit.stats.name] = [unit]
	
	return unit_counts
