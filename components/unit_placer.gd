class_name UnitPlacer
extends Node

const HALF_CELL_SIZE := Vector2(16, 16)

@export var play_areas: Array[PlayArea]


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		unit.drag_started.connect(_on_unit_drag_started.bind(unit))
		unit.drag_canceled.connect(_on_unit_drag_canceled)
		unit.dropped.connect(_on_unit_dropped.bind(unit))


func _set_highlighters(enabled: bool) -> void:
	for play_area: PlayArea in play_areas:
		play_area.tile_highlighter.enabled = enabled


func _get_play_area_for_position(global: Vector2) -> int:
	var dropped_area_index := -1
	
	for i in play_areas.size():
		var tile := play_areas[i].local_to_map(play_areas[i].to_local(global))
		if play_areas[i].is_tile_in_bounds(tile):
			dropped_area_index = i
	
	return dropped_area_index


func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)
	
	for i in play_areas.size():
		var tile := play_areas[i].get_tile_from_global(unit.global_position)
		
		if play_areas[i].is_tile_in_bounds(tile):
			var grid := play_areas[i].get_grid_coordinate(tile)
			play_areas[i].unit_grid.set_cell_unit(grid, null)
			return


func _on_unit_drag_canceled() -> void:
	_set_highlighters(false)


func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	
	var original_index := _get_play_area_for_position(starting_position)
	var original_tile := play_areas[original_index].get_tile_from_global(starting_position)
	var original_grid := play_areas[original_index].get_grid_coordinate(original_tile)
	var dropped_area_index := _get_play_area_for_position(unit.get_global_mouse_position())
	
	if dropped_area_index == -1:
		unit.reset_after_dragging(starting_position)
		play_areas[original_index].unit_grid.set_cell_unit(original_grid, unit)
		return

	var new_area := play_areas[dropped_area_index]
	var hovered_tile := new_area.get_hovered_tile()
	var grid := new_area.get_grid_coordinate(hovered_tile)
	var final_local_position := new_area.map_to_local(hovered_tile) - HALF_CELL_SIZE
	
	# swap units if we have to
	if new_area.unit_grid.is_tile_occupied(grid):
		play_areas[original_index].unit_grid.set_cell_unit(original_grid, new_area.unit_grid.units[grid])
		new_area.unit_grid.units[grid].global_position = starting_position
	
	unit.global_position = new_area.to_global(final_local_position)
	new_area.unit_grid.set_cell_unit(grid, unit)