class_name BenchItems
extends Node2D

const BENCH_ITEM := preload("res://scenes/bench_item/bench_item.tscn")

var slots: Array[Marker2D]


func _ready() -> void:
	for marker: Marker2D in get_children():
		slots.append(marker)
	
	# NOTE test code
	var items := [
		preload("res://data/items/ring.tres"),
		preload("res://data/items/gloves.tres"),
		preload("res://data/items/sword.tres")
	]
	for _i: int in slots.size():
		add_item(items.pick_random())


func return_items_from_unit(unit: Unit) -> void:
	for item: Item in unit.item_handler.equipped_items:
		if item:
			add_item(item)


func add_item(item: Item) -> void:
	var slot := _get_first_available_slot()
	
	if not slot:
		print("No empty space for item!")
	
	var bench_item := BENCH_ITEM.instantiate()
	slot.add_child(bench_item)
	bench_item.item = item


func _get_first_available_slot() -> Marker2D:
	for slot: Marker2D in slots:
		if slot.get_child_count() == 0:
			return slot
	
	return null
