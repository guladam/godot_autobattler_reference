class_name DebugDraw
extends Node2D

@export var color: Color
var path: PackedVector2Array


func _draw() -> void:
	if path:
		for tile: Vector2 in path:
			draw_rect(Rect2(tile, Arena.CELL_SIZE), color)


func _process(_delta: float) -> void:
	queue_redraw()
