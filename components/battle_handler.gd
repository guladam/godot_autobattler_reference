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

var battle_unit_coordinates: Dictionary[BattleUnit, Vector2i]


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
	get_tree().call_group("units", "show")
	get_tree().call_group("units", "disable_collision", false)


func _setup_battle_unit(unit_coord: Vector2i, new_unit: BattleUnit) -> void:
	new_unit.stats.reset_health()
	new_unit.stats.reset_mana()
	new_unit.global_position = game_area.get_global_from_tile(unit_coord) + Vector2(0, -Arena.QUARTER_CELL_SIZE.y)
	new_unit.tree_exited.connect(_on_battle_unit_died)
	battle_unit_grid.add_unit(unit_coord, new_unit)


func _add_items(unit: Unit, new_unit: BattleUnit) -> void:
	for item in unit.item_handler.equipped_items:
		new_unit.item_handler.add_item(item)
	
	# NOTE this was previously inside setup battle unit BUT --> we simultaneously called this which copies battle unit items 
	# to OG units while iterating through the items of the OG unit above, leading to an error where not all items of units 
	# were copied over to battle units!
	new_unit.item_handler.items_changed.connect(_on_battle_unit_items_changed.bind(new_unit))
	new_unit.item_handler.item_removed.connect(_on_battle_unit_item_removed.bind(new_unit))
	_on_battle_unit_items_changed(new_unit)


func _add_trait_bonuses(new_unit: BattleUnit) -> void:
	for unit_trait: Trait in new_unit.stats.traits:
		if trait_tracker.active_traits.has(unit_trait):
			var trait_bonus := unit_trait.get_active_bonus(trait_tracker.unique_traits[unit_trait])
			trait_bonus.apply_bonus(new_unit)


func _prepare_fight() -> void:
	get_tree().call_group("units", "disable_collision", true)
	get_tree().call_group("units", "hide")
	battle_unit_coordinates.clear()
	
	for unit_coord: Vector2i in game_area_unit_grid.get_all_occupied_tiles():
		var unit: Unit = game_area_unit_grid.units[unit_coord]
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("player_units")
		new_unit.stats = unit.stats
		battle_unit_coordinates[new_unit] = unit_coord
		_setup_battle_unit(unit_coord, new_unit)
		_add_items(unit, new_unit)
		_add_trait_bonuses(new_unit)
	
	for unit_coord: Vector2i in ZOMBIE_TEST_POSITIONS:
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("enemy_units")
		new_unit.stats = ZOMBIE
		new_unit.stats.team = UnitStats.Team.ENEMY
		_setup_battle_unit(unit_coord, new_unit)
	
	UnitNavigation.update_occupied_tiles()
	var battle_units := get_tree().get_nodes_in_group("player_units") + get_tree().get_nodes_in_group("enemy_units")
	battle_units.shuffle()
	
	for battle_unit: BattleUnit in battle_units:
		battle_unit.unit_ai.enabled = true

		for item: Item in battle_unit.item_handler.equipped_items:
			item.apply_bonus_effect(battle_unit)


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


func _on_battle_unit_items_changed(battle_unit: BattleUnit) -> void:
	var coord := battle_unit_coordinates[battle_unit]
	var unit := game_area_unit_grid.units[coord] as Unit
	battle_unit.item_handler.copy_items_to(unit.item_handler)
	
	for item: Item in battle_unit.item_handler.equipped_items:
		item.remove_modifiers(battle_unit)
		item.apply_modifiers(battle_unit)
		#item.apply_bonus_effect(battle_unit) # NOTE this shouldn't be here, only at start of battle BUT depends on how you want your game to work


func _on_battle_unit_item_removed(item: Item, battle_unit: BattleUnit) -> void:
	item.remove_modifiers(battle_unit)


func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
