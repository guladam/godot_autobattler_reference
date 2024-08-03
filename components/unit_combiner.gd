class_name UnitCombiner
extends Node

const COMBINE_ANIM_LENGTH := 0.6
const COMBINE_BUFFER := 1.0
const COMBINE_ANIM_SCALE := Vector2(0.7, 0.7)

@export var buffer_timer: Timer

var queued_updates := 0
var tween: Tween


func _ready() -> void:
	buffer_timer.wait_time = COMBINE_BUFFER
	buffer_timer.timeout.connect(_on_buffer_timer_timeout)


func queue_unit_combination_update() -> void:
	buffer_timer.start()


func _update_unit_combinations(tier: int) -> void:
	var units := get_tree().get_nodes_in_group("units")
	var tier_upgrades: Array[Array] = []
	var tier_groups := _group_units_by_name_and_tier(units, tier)
		
	for unit_name in tier_groups:
		var current_units: Array = tier_groups[unit_name]
		while current_units.size() >= 3:
			var combination := [current_units[0], current_units[1], current_units[2]]
			tier_upgrades.append(combination)
			current_units = current_units.slice(3)

	if tier_upgrades.is_empty():
		_on_units_combined(tier)
		return

	tween = create_tween()
	
	for combination in tier_upgrades:
		tween.tween_callback(_combine_units.bind(combination[0], combination[1], combination[2]))
		tween.tween_interval(COMBINE_ANIM_LENGTH)
		
	tween.finished.connect(_on_units_combined.bind(tier), CONNECT_ONE_SHOT)


func _combine_units(unit1: Unit, unit2: Unit, unit3: Unit) -> void:
	unit1.stats.tier += 1
	unit2.remove_from_group("units")
	unit3.remove_from_group("units")
	UnitGrid.remove_unit_from_grid(unit2)
	UnitGrid.remove_unit_from_grid(unit3)
	unit2.play_combine_animation(unit1.global_position + Arena.QUARTER_CELL_SIZE)
	unit3.play_combine_animation(unit1.global_position + Arena.QUARTER_CELL_SIZE)


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


func _on_buffer_timer_timeout() -> void:
	queued_updates += 1
	
	if not tween or not tween.is_running():
		_update_unit_combinations(1)


func _on_units_combined(tier: int) -> void:
	if tier == 1:
		_update_unit_combinations(2)
	else:
		queued_updates -= 1
		if queued_updates >= 1:
			_update_unit_combinations(1)
