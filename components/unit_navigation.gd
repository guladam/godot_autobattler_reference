extends Node

var battle_grid: UnitGrid
var astar_grid: AStarGrid2D
var full_grid_region: Rect2i


func initialize(battle_grid_node: UnitGrid) -> void:
	battle_grid = battle_grid_node
	battle_grid.unit_grid_changed.connect(_on_grid_changed)
	
	full_grid_region = Rect2i(0, 0, battle_grid.size.x, battle_grid.size.y)
	astar_grid = AStarGrid2D.new()
	astar_grid.region = full_grid_region
	astar_grid.cell_size = Arena.CELL_SIZE
	astar_grid.update()


func setup() -> void:
	astar_grid.fill_solid_region(full_grid_region, false)
	for id: Vector2i in battle_grid.get_all_occupied_tiles():
		astar_grid.set_point_solid(id)


func _on_grid_changed() -> void:
	pass
