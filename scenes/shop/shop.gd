class_name Shop
extends Control

signal unit_bought(unit: UnitStats)

const SHOP_UNIT_CARD = preload("res://scenes/shop_unit_card/shop_unit_card.tscn")

@export var unit_pool: UnitPool
@onready var shop_cards: VBoxContainer = %ShopCards


func _ready() -> void:
	unit_pool.generate_unit_pool()
	
	for child: Node in shop_cards.get_children():
		child.queue_free()

	_roll_units()


func _roll_units() -> void:
	for i in 5:
		var new_card := SHOP_UNIT_CARD.instantiate() as ShopUnitCard
		new_card.unit_stats = unit_pool.get_random_unit_by_tier(1)
		new_card.unit_bought.connect(_on_unit_bought)
		shop_cards.add_child(new_card)


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
