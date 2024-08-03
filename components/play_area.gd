class_name PlayArea
extends TileMap

@export var starting_coordinate: Vector2i
@export var unit_grid: UnitGrid
@export var tile_highlighter: TileHighlighter

var bounds: Rect2i


func _ready() -> void:
	bounds = Rect2i(starting_coordinate, unit_grid.size)

# TODO check where and how we need this
func get_grid_coordinate_from_tile(tile: Vector2i) -> Vector2i:
	return tile - starting_coordinate


func get_tile_from_grid_coordinate(grid: Vector2i) -> Vector2i:
	return grid + starting_coordinate


func get_tile_from_local(local: Vector2) -> Vector2i:
	return local_to_map(local)


func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))


func get_global_from_tile(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))


func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())


func is_tile_in_bounds(tile: Vector2i) -> bool:
	return bounds.has_point(tile)
