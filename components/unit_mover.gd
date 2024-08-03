# STILL TODO!
class_name UnitMover
extends Node

@export var play_areas: Array[PlayArea]


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))


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
	
	var index := _get_play_area_for_position(unit.global_position)
	if index > -1:
		var tile := play_areas[index].get_tile_from_global(unit.global_position) # TODO simplify this somehow
		var grid_coord := play_areas[index].get_grid_coordinate_from_tile(tile)  # TODO simplify this somehow
		play_areas[index].unit_grid.set_cell_unit(grid_coord, null)


# FIXME this violates DRY, we do virtually the same thing
# in _on_unit_dropped() when we drop to an invalid position
func _on_unit_drag_canceled(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	
	var original_index := _get_play_area_for_position(starting_position)
	var original_tile := play_areas[original_index].get_tile_from_global(starting_position)
	var original_grid := play_areas[original_index].get_grid_coordinate_from_tile(original_tile)

	unit.reset_after_dragging(starting_position)
	play_areas[original_index].unit_grid.set_cell_unit(original_grid, unit)


func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	
	# unit is sold to the portal and about to be deleted,
	# we can return immediately
	if unit.is_queued_for_deletion():
		return
	
	var original_index := _get_play_area_for_position(starting_position)
	var original_tile := play_areas[original_index].get_tile_from_global(starting_position)
	var original_grid := play_areas[original_index].get_grid_coordinate_from_tile(original_tile)
	var dropped_area_index := _get_play_area_for_position(unit.get_global_mouse_position())
	
	if dropped_area_index == -1:
		unit.reset_after_dragging(starting_position)
		play_areas[original_index].unit_grid.set_cell_unit(original_grid, unit)
		return

	var new_area := play_areas[dropped_area_index]
	var hovered_tile := new_area.get_hovered_tile()
	var grid := new_area.get_grid_coordinate_from_tile(hovered_tile)
	var final_local_position := new_area.map_to_local(hovered_tile) - Arena.HALF_CELL_SIZE
	
	# swap units if we have to
	if new_area.unit_grid.is_tile_occupied(grid):
		var old_unit: Unit = new_area.unit_grid.units[grid]
		play_areas[original_index].unit_grid.set_cell_unit(original_grid, new_area.unit_grid.units[grid])
		old_unit.global_position = starting_position
		old_unit.reparent(play_areas[original_index].unit_grid)
	
	new_area.unit_grid.set_cell_unit(grid, unit)
	unit.global_position = new_area.to_global(final_local_position)
	unit.reparent(new_area.unit_grid)
