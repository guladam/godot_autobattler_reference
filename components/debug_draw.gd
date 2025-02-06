class_name DebugDraw
extends Node2D

@export var color: Color


func _draw() -> void:
	for i in UnitNavigation.astar_grid.region.size.x:
		for j in UnitNavigation.astar_grid.region.size.y:
			if UnitNavigation.astar_grid.is_point_solid(Vector2i(i, j)):
				draw_rect(Rect2(Vector2(i, j) * Arena.CELL_SIZE, Arena.CELL_SIZE), color)


func _process(_delta: float) -> void:
	queue_redraw()
