class_name UnitCombiner
extends Node


# TODO rethink this so it works simultaneously
# maybe just insta-remove combining units from groups???
func update_unit_combinations(_unit: Unit) -> void:
	var units := get_tree().get_nodes_in_group("units")
	var tier1_groups := _group_units_by_name_and_tier(units, 1)
	
	for unit_name in tier1_groups:
		var current_units: Array = tier1_groups[unit_name]
		while current_units.size() >= 3:
			print("combining 3 tier ones...")
			print(current_units)
			current_units[0].stats.tier += 1
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
