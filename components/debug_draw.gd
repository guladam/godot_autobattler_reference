class_name DebugDraw
extends Node2D

@export var color: Color
@export var game_area: PlayArea

var paths := {}


func _ready() -> void:
	UnitNavigation.astar_path_calculated.connect(_on_astar_path_calculated)


func _draw() -> void:
	for i in UnitNavigation.astar_grid.region.size.x:
		for j in UnitNavigation.astar_grid.region.size.y:
			if UnitNavigation.astar_grid.is_point_solid(Vector2i(i, j)):
				draw_rect(Rect2(Vector2(i, j) * Arena.CELL_SIZE, Arena.CELL_SIZE), color)
	
	for path in paths.values():
		draw_path(path)


func _process(_delta: float) -> void:
	queue_redraw()


func draw_path(points: Array[Vector2i]) -> void:
	for i in range(1, points.size()):
		draw_line(game_area.get_global_from_tile(points[i-1]) - global_position, game_area.get_global_from_tile(points[i]) - global_position, Color.FIREBRICK)


func _on_astar_path_calculated(path: Array[Vector2i], unit: BattleUnit) -> void:
	paths[unit] = path
