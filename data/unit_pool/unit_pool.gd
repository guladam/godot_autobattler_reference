class_name UnitPool
extends Resource

@export var available_units: Array[UnitStats]

var unit_pool: Array[UnitStats]


func generate_unit_pool() -> void:
	unit_pool = []
	
	for unit: UnitStats in available_units:
		for i in unit.pool_count:
			unit_pool.append(unit)


func get_random_unit_by_tier(tier: int) -> UnitStats:
	var units := unit_pool.filter(
		func(unit: UnitStats):
			return unit.tier == tier
	)
	var picked_unit: UnitStats = units.pick_random()
	unit_pool.erase(picked_unit)
	
	return picked_unit


func add_unit(unit: UnitStats) -> void:
	unit_pool.append(unit)
