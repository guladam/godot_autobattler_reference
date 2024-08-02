class_name UnitGrid
extends Node2D

signal unit_grid_changed

@export var size: Vector2i

var units: Dictionary


func _ready() -> void:
	for i in size.x:
		for j in size.y:
			units[Vector2i(i, j)] = null


func set_cell_unit(tile: Vector2i, unit: Node) -> void:
	units[tile] = unit
	unit_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null


func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile

	# no empty tile
	return Vector2i(-1, -1)


func get_all_units() -> Array[Unit]:
	var unit_array: Array[Unit] = []
	
	for unit: Unit in units.values():
		if unit:
			unit_array.append(unit)
	
	return unit_array


func get_all_unit_stats() -> Array[UnitStats]:
	var unit_stats: Array[UnitStats] = []
	
	for unit: Unit in units.values():
		if unit:
			unit_stats.append(unit.stats)
	
	return unit_stats


static func get_unit_grid_for_unit(unit: Unit) -> UnitGrid:
	var unit_grids := unit.get_tree().get_nodes_in_group("unit_grids")
	for unit_grid: UnitGrid in unit_grids:
		if unit_grid.units.values().has(unit):
			return unit_grid
	
	return null


static func remove_unit_from_grid(unit: Unit) -> void:
	var grid := get_unit_grid_for_unit(unit)
	if not grid:
		return
		
	for tile: Vector2i in grid.units.keys():
		if grid.units[tile] == unit:
			grid.set_cell_unit(tile, null)
			return

# NOTE might need these in the future
#func is_tile_in_bounds(tile: Vector2i) -> bool:
	#return tile.x >= 0 and tile.x < size.x and tile.y >= 0 and tile.y < size.y
#
#
#func is_tile_type(tile: Vector2i, group: StringName) -> bool:
	#return units[tile] and units[tile].is_in_group(group)
#
#
#func get_tiles_by_type(group: StringName) -> Array:
	#return units.keys().filter(is_tile_type.bind(group))
#
#
#func get_random_tile() -> Vector2i:
	#return Vector2i(randi() % size.x, randi() % size.y)
#
#
#func get_random_unoccupied_tile() -> Vector2i:
	#var tile := get_random_tile()
	#
	#while is_tile_occupied(tile):
		#tile = get_random_tile()
		#
	#return tile
