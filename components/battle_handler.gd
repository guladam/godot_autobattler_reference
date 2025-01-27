class_name BattleHandler
extends Node

@export var game_state: GameState
@export var arena_unit_grid: UnitGrid


func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test1"):
		game_state.current_phase = GameState.Phase.PREPARATION
	if event.is_action_pressed("test2"):
		game_state.current_phase = GameState.Phase.FIGHT


func _clean_up_fight() -> void:
	get_tree().call_group("player_units", "queue_free")
	get_tree().call_group("enemy_units", "queue_free")
	get_tree().call_group("units", "show")


func _prepare_fight() -> void:
	for unit: Unit in arena_unit_grid.get_all_units():
		var new_unit: Unit = UnitSpawner.UNIT.instantiate()
		new_unit.remove_from_group("units")
		new_unit.add_to_group("player_units")
		arena_unit_grid.add_child(new_unit)
		new_unit.stats = unit.stats
		new_unit.quick_sell.enabled = false
		new_unit.drag_and_drop.enabled = false
		new_unit.global_position = unit.global_position
		new_unit.modulate = Color.GREEN_YELLOW
		unit.hide()


func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.FIGHT:
			_prepare_fight()
