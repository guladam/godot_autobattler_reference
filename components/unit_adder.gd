class_name UnitAdder
extends Node

signal unit_added(unit: Unit)

const HALF_CELL_SIZE := Vector2(16, 16) # TODO duplicate in UnitMover
const UNIT = preload("res://scenes/unit/unit.tscn")

@export var bench: PlayArea
@export var game_area: PlayArea


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("unit_add"):
		add_unit(preload("res://data/units/bjorn.tres"))


func _get_first_available_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	
	# everything is full
	return null


func add_unit(unit: UnitStats) -> void:
	var area := _get_first_available_area()
	assert(area, "No available space to add unit to!")
	
	var new_unit := UNIT.instantiate()
	var grid := area.unit_grid.get_first_empty_tile()
	var tile := area.get_tile_from_grid(grid)
	area.unit_grid.add_child(new_unit)
	area.unit_grid.set_cell_unit(grid, new_unit)
	new_unit.global_position = area.get_global_from_tile(tile) - HALF_CELL_SIZE
	new_unit.stats = unit
	unit_added.emit(new_unit)
