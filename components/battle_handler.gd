class_name BattleHandler
extends Node

signal battle_ended

const BATTLE_UNIT = preload("res://scenes/battle_unit/battle_unit.tscn")

@export var game_state: GameState
@export var game_area_unit_grid: UnitGrid
@export var game_area_tile_highlighter: TileHighlighter


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
	for unit: Unit in game_area_unit_grid.get_all_units():
		var new_unit: BattleUnit = BATTLE_UNIT.instantiate()
		new_unit.add_to_group("player_units")
		game_area_unit_grid.add_child(new_unit)
		new_unit.collision_layer = 1
		new_unit.collision_mask = 2
		new_unit.stats = unit.stats
		new_unit.global_position = unit.global_position + Vector2(Arena.HALF_CELL_SIZE.x, Arena.QUARTER_CELL_SIZE.y)
		new_unit.modulate = Color.GREEN_YELLOW
		new_unit.tree_exited.connect(_on_battle_unit_died)
		unit.disable_collision(true)
		unit.hide()
	
	for enemy: BattleUnit in get_tree().get_nodes_in_group("enemy_units"):
		enemy.stats.team = UnitStats.Team.ENEMY
		enemy.tree_exited.connect(_on_battle_unit_died)


func _on_battle_unit_died() -> void:
	# We already concluded the battle!
	# or we quitting the game
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
