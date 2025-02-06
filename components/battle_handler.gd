# NOTE this class could be cleaned up a lot because right now it does quite a bit of everything
# maybe a BattleUnitSpawner component could be used separately to handle that functionality
# or event a PackedSceneSpawner component which returns the newly spawned node -->
# then, the unit_spawner and battle_unit_spawner components would share some code
class_name BattleHandler
extends Node

signal battle_ended

const BATTLE_UNIT = preload("res://scenes/battle_unit/battle_unit.tscn")

@export var game_state: GameState
@export var game_area: PlayArea
@export var game_area_unit_grid: UnitGrid
@export var battle_unit_grid: UnitGrid

@onready var debug_draw: DebugDraw = $DebugDraw


func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)


# NOTE testing code
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test1"):
		get_tree().call_group("player_units", "queue_free")
		#game_state.current_phase = GameState.Phase.PREPARATION
		#battle_ended.emit()
	if event.is_action_pressed("test2"):
		get_tree().call_group("enemy_units", "queue_free")
		#game_state.current_phase = GameState.Phase.BATTLE


func _clean_up_fight() -> void:
	get_tree().call_group("player_units", "queue_free")
	get_tree().call_group("enemy_units", "queue_free")
	get_tree().call_group("units", "show")
	get_tree().call_group("units", "disable_collision", false)


func _prepare_fight() -> void:
	for unit_coord: Vector2i in game_area_unit_grid.get_all_occupied_tiles():
		var unit: Unit = game_area_unit_grid.units[unit_coord]
		var new_unit: BattleUnit = BATTLE_UNIT.instantiate()
		new_unit.add_to_group("player_units")
		battle_unit_grid.add_child(new_unit)
		new_unit.collision_layer = 1
		new_unit.collision_mask = 2
		new_unit.stats = unit.stats
		new_unit.global_position = game_area.get_global_from_tile(unit_coord) + Vector2(0, -Arena.QUARTER_CELL_SIZE.y)
		new_unit.modulate = Color.GREEN_YELLOW
		new_unit.tree_exited.connect(_on_battle_unit_died)
		battle_unit_grid.add_unit(unit_coord, new_unit)
		unit.disable_collision(true)
		unit.hide()
	
	for tile: Vector2i in [Vector2i(8, 1), Vector2i(7, 4), Vector2i(9, 6)]:
		var new_unit: BattleUnit = BATTLE_UNIT.instantiate()
		new_unit.add_to_group("enemy_units")
		battle_unit_grid.add_child(new_unit)
		new_unit.collision_layer = 2
		new_unit.collision_mask = 1
		new_unit.stats = preload("res://data/enemies/zombie.tres")
		new_unit.global_position = game_area.get_global_from_tile(tile) + Vector2(0, -Arena.QUARTER_CELL_SIZE.y)
		battle_unit_grid.add_unit(tile, new_unit)
		new_unit.stats.team = UnitStats.Team.ENEMY
		new_unit.tree_exited.connect(_on_battle_unit_died)
	
	UnitNavigation.setup()
	var battle_units := get_tree().get_nodes_in_group("player_units") + get_tree().get_nodes_in_group("enemy_units")
	for i in range(UnitStats.MAX_ATTACK_RANGE, 0, -1):
		var units := battle_units.filter(func(battle_unit: BattleUnit): return battle_unit.stats.get_movement_priority() == i)
		for battle_unit: BattleUnit in units:
			battle_unit.unit_ai.enabled = true
	

func _on_battle_unit_died() -> void:
	# We already concluded the battle!
	# or we are quitting the game
	if not get_tree() or game_state.current_phase == GameState.Phase.PREPARATION:
		return
	
	if get_tree().get_node_count_in_group("enemy_units") == 0:
		game_state.current_phase = GameState.Phase.PREPARATION
		battle_ended.emit()
		print("player won!")
	if get_tree().get_node_count_in_group("player_units") == 0:
		game_state.current_phase = GameState.Phase.PREPARATION
		battle_ended.emit()
		print("enemy won!")


func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
