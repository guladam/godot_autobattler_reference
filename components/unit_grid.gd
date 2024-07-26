class_name UnitGrid
extends Node

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


func is_tile_in_bounds(tile: Vector2i) -> bool:
	return tile.x >= 0 and tile.x < size.x and tile.y >= 0 and tile.y < size.y


func is_tile_type(tile: Vector2i, group: StringName) -> bool:
	return units[tile] and units[tile].is_in_group(group)


func get_tiles_by_type(group: StringName) -> Array:
	return units.keys().filter(is_tile_type.bind(group))


func get_random_tile() -> Vector2i:
	return Vector2i(randi() % size.x, randi() % size.y)


func get_random_unoccupied_tile() -> Vector2i:
	var tile := get_random_tile()
	
	while is_tile_occupied(tile):
		tile = get_random_tile()
		
	return tile
