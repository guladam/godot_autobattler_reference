class_name BattleHandler
extends Node

signal battle_ended

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


func _prepare_fight() -> void:
	for unit: Unit in game_area_unit_grid.get_all_units():
		var new_unit: Unit = UnitSpawner.UNIT.instantiate()
		new_unit.remove_from_group("units")
		new_unit.add_to_group("player_units")
		game_area_unit_grid.add_child(new_unit)
		new_unit.stats = unit.stats
		new_unit.quick_sell.enabled = false
		new_unit.drag_and_drop.enabled = false
		new_unit.global_position = unit.global_position
		new_unit.modulate = Color.GREEN_YELLOW
		new_unit.tree_exited.connect(_on_battle_unit_died)
		unit.hide()
	
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy_units"):
		enemy.tree_exited.connect(_on_battle_unit_died)


func _on_battle_unit_died() -> void:
	# We already concluded the battle!
	if game_state.current_phase == GameState.Phase.PREPARATION:
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
