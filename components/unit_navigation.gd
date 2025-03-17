extends Node

var battle_grid: UnitGrid
var game_area: PlayArea
var astar_grid: AStarGrid2D
var full_grid_region: Rect2i


func initialize(battle_grid_node: UnitGrid, game_area_node: PlayArea) -> void:
	game_area = game_area_node
	battle_grid = battle_grid_node
	battle_grid.unit_grid_changed.connect(_on_grid_changed)
	
	full_grid_region = Rect2i(0, 0, battle_grid.size.x, battle_grid.size.y)
	astar_grid = AStarGrid2D.new()
	astar_grid.region = full_grid_region
	astar_grid.cell_size = Arena.CELL_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()


func setup() -> void:
	astar_grid.fill_solid_region(full_grid_region, false)
	for id: Vector2i in battle_grid.get_all_occupied_tiles():
		astar_grid.set_point_solid(id)


func get_next_position(moving_unit: BattleUnit, target_unit: BattleUnit) -> Vector2:
	var unit_tile := game_area.get_tile_from_global(moving_unit.global_position)
	var target_tile := game_area.get_tile_from_global(target_unit.global_position)
	
	# TODO this should be the closest adjacent empty, because
	# otherwise units might go to weird places sometimes :D
	target_tile = battle_grid.get_adjacent_empty_tile(target_tile)
	
	# there is no adjacent tile empty before target
	if target_tile == Vector2i(-1, -1):
		return Vector2(-1, -1)
	
	battle_grid.remove_unit(unit_tile)
	astar_grid.set_point_solid(unit_tile, false)
	var path := astar_grid.get_id_path(unit_tile, target_tile)
	
	# there is no adjacent tile next to the moving unit
	if path.is_empty():
		return Vector2(-1, -1)
	
	var next_tile := path[1]
	battle_grid.add_unit(next_tile, moving_unit)
	astar_grid.set_point_solid(next_tile, true)
	
	return game_area.get_global_from_tile(next_tile)


func _on_grid_changed() -> void:
	pass
