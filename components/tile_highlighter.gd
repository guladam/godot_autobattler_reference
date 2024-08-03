class_name TileHighlighter
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var play_area: PlayArea
@export var layer: int
@export var tile: Vector2i

@onready var source_id := play_area.tile_set.get_source_id(0)


func _process(_delta: float) -> void:
	if not enabled:
		return

	var selected_tile := play_area.get_hovered_tile()
	
	if not play_area.is_tile_in_bounds(selected_tile):
		_clear_highlight()
		return

	_update_tile(selected_tile)


func _set_enabled(new_value: bool) -> void:
	enabled = new_value
	
	if not enabled and play_area:
		play_area.clear_layer(layer)


func _clear_highlight() -> void:
	play_area.clear_layer(layer)


func _update_tile(selected_tile: Vector2i) -> void:
	_clear_highlight()
	play_area.set_cell(layer, selected_tile, source_id, tile)
