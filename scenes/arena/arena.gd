class_name Arena
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := Vector2(16, 16)
const QUARTER_CELL_SIZE := Vector2(8, 8)

@export var arena_music_stream: AudioStream

@onready var game_area: PlayArea = $GameArea
@onready var battle_grid: UnitGrid = $BattleGrid
@onready var sell_portal: SellPortal = $SellPortal
@onready var bench_items: BenchItems = $BenchItems
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var unit_combiner: UnitCombiner = $UnitCombiner
@onready var battle_handler: BattleHandler = $BattleHandler
@onready var trait_tracker: TraitTracker = $TraitTracker
@onready var shop: Shop = %Shop
@onready var traits: Traits = %Traits


func _ready() -> void:
	UnitNavigation.initialize(battle_grid, game_area)
	sell_portal.unit_sold.connect(bench_items.return_items_from_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(unit_combiner.queue_unit_combination_update.unbind(1))
	battle_handler.battle_ended.connect(unit_combiner.queue_unit_combination_update)
	shop.unit_bought.connect(unit_spawner.spawn_unit)
	trait_tracker.traits_changed.connect(traits.update_traits)
	
	MusicPlayer.play(arena_music_stream)
