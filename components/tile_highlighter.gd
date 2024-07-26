class_name TileHighlighter
extends Node

@export var enabled: bool = true : set = set_enabled
@export var tilemap: TileMap
@export var layer: int
@export var tile: Vector2i
@export var bound_limit_start: Vector2i
@export var bound_limit_size: Vector2i

var bounds: Rect2i

@onready var source_id := tilemap.tile_set.get_source_id(0)


func _ready() -> void:
	bounds = Rect2i(bound_limit_start, bound_limit_size)


func _process(_delta: float) -> void:
	if not enabled:
		return

	var selected_tile := tilemap.local_to_map(tilemap.get_local_mouse_position())

	if not bounds.has_point(selected_tile):
		_clear_highlight()
		return

	_update_tile(selected_tile)


func set_enabled(new_value: bool) -> void:
	enabled = new_value
	
	if not enabled and tilemap:
		tilemap.clear_layer(layer)


func _clear_highlight() -> void:
	tilemap.clear_layer(layer)


func _update_tile(selected_tile: Vector2i) -> void:
	_clear_highlight()
	tilemap.set_cell(layer, selected_tile, source_id, tile)
