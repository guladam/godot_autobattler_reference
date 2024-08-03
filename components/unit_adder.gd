class_name UnitAdder
extends Node

signal unit_added(unit: Unit)

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var bench: PlayArea
@export var game_area: PlayArea


func _get_first_available_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	
	return null


func add_unit(unit: UnitStats) -> void:
	var area := _get_first_available_area()
	# TODO in the future, throw a popup error message here!
	assert(area, "No available space to add unit to!")
	
	var new_unit := UNIT.instantiate()
	var grid := area.unit_grid.get_first_empty_tile()    # TODO this might change if I refactor it
	var tile := area.get_tile_from_grid_coordinate(grid) # TODO this might change if I refactor it
	area.unit_grid.add_child(new_unit)
	area.unit_grid.set_cell_unit(grid, new_unit)
	new_unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE # TODO this might change if I refactor it
	new_unit.stats = unit
	unit_added.emit(new_unit)
	
