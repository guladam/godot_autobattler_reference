class_name BattleHandler
extends Node

const ZOMBIE_TEST_POSITIONS := [
	Vector2i(8, 1),
	Vector2i(7, 4),
	Vector2i(8, 3),
	Vector2i(9, 5),
	Vector2i(9, 6)
]
const ZOMBIE := preload("res://data/enemies/zombie.tres")

signal battle_ended

@export var game_state: GameState
@export var game_area: PlayArea
@export var game_area_unit_grid: UnitGrid
@export var battle_unit_grid: UnitGrid
@export var trait_tracker: TraitTracker

@onready var scene_spawner: SceneSpawner = $SceneSpawner

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
	get_tree().call_group("unit_abilities", "queue_free") # NOTE: see unity_ability.gd _ready
	get_tree().call_group("trait_bonuses", "queue_free")
	get_tree().call_group("units", "show")
	get_tree().call_group("units", "disable_collision", false)


func _setup_battle_unit(unit_coord: Vector2i, new_unit: BattleUnit) -> void:
	new_unit.stats.reset_health()
	new_unit.stats.reset_mana()
	new_unit.global_position = game_area.get_global_from_tile(unit_coord) + Vector2(0, -Arena.QUARTER_CELL_SIZE.y)
	new_unit.tree_exited.connect(_on_battle_unit_died)
	battle_unit_grid.add_unit(unit_coord, new_unit)


func _prepare_fight() -> void:
	get_tree().call_group("units", "disable_collision", true)
	get_tree().call_group("units", "hide")
	
	for unit_coord: Vector2i in game_area_unit_grid.get_all_occupied_tiles():
		var unit: Unit = game_area_unit_grid.units[unit_coord]
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("player_units")
		new_unit.stats = unit.stats
		_setup_battle_unit(unit_coord, new_unit)
	
	for unit_coord: Vector2i in ZOMBIE_TEST_POSITIONS:
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("enemy_units")
		new_unit.stats = ZOMBIE
		new_unit.stats.team = UnitStats.Team.ENEMY
		_setup_battle_unit(unit_coord, new_unit)
	
	var player_units := get_tree().get_nodes_in_group("player_units")
	var enemy_units := get_tree().get_nodes_in_group("enemy_units")
	
	for active_trait: Trait in trait_tracker.active_traits:
		var bonus_node := active_trait.trait_bonus_script.new(active_trait) as TraitBonus
		add_child(bonus_node)
		bonus_node.apply_bonus()
	
	UnitNavigation.update_occupied_tiles()
	var battle_units := player_units + enemy_units
	battle_units.shuffle()
	
	for battle_unit: BattleUnit in battle_units:
		battle_unit.unit_ai.enabled = true


func _end_current_battle() -> void:
	game_state.current_phase = GameState.Phase.PREPARATION
	battle_ended.emit()


func _on_battle_unit_died() -> void:
	# We already concluded the battle!
	# or we are quitting the game
	if not get_tree() or game_state.current_phase == GameState.Phase.PREPARATION:
		return
	
	if get_tree().get_node_count_in_group("enemy_units") == 0:
		print("player won!")
		_end_current_battle()
	if get_tree().get_node_count_in_group("player_units") == 0:
		print("enemy won!")
		_end_current_battle()


func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
