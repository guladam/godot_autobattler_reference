class_name Shop
extends Control

signal unit_bought(unit: UnitStats)

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats

@onready var shop_cards: VBoxContainer = %ShopCards
@onready var card_spawner: SceneSpawner = $UnitCardSpawner


func _ready() -> void:
	unit_pool.generate_unit_pool()
	
	for child: Node in shop_cards.get_children():
		child.queue_free()

	_roll_units()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test1"):
		player_stats.gold = 99


func _roll_units() -> void:
	for i in 5:
		var rarity := player_stats.get_random_rarity_for_level()
		var new_card := card_spawner.spawn_scene(shop_cards) as ShopUnitCard
		new_card.unit_stats = unit_pool.get_random_unit_by_rarity(rarity)
		new_card.unit_bought.connect(_on_unit_bought)


func _put_back_remaining_to_pool() -> void:
	for shop_card: ShopUnitCard in shop_cards.get_children():
		if not shop_card.bought:
			unit_pool.add_unit(shop_card.unit_stats)
		
		shop_card.queue_free()


func _on_unit_bought(unit: UnitStats) -> void:
	unit_bought.emit(unit)


func _on_reroll_button_pressed() -> void:
	_put_back_remaining_to_pool()
	_roll_units()
