# TODO might move the array actually to the unitstats resource?
class_name ItemHandler
extends Node

signal items_changed

const MAX_ITEMS_HELD := 3

@export var item_db: ItemDB
@export var equipped_items: Array[Item] = []


func _ready() -> void:
	items_changed.connect(func(): print(equipped_items))


func add_item(new_item: Item) -> bool:
	# Get recipe for combining new item with an existing one
	# TODO rename combine_item_components
	var recipe := item_db.combine_item_components(equipped_items, new_item)
	# If there's one, we combine them
	if recipe:
		_combine_components(recipe, new_item)
		return true
	# If not, we try to equip the item as is
	else:
		return _try_equipping_item(new_item)


func _combine_components(recipe: ItemRecipe, new_item: Item) -> void:
	var equipped_component := recipe.get_other_source_item(new_item)
	var idx := equipped_items.find(equipped_component)
	equipped_items[idx] = recipe.result
	items_changed.emit()


func _try_equipping_item(item: Item) -> bool:
	if equipped_items.size() >= MAX_ITEMS_HELD:
		print("No available item slots!")
		return false
	
	equipped_items.append(item)
	items_changed.emit()
	return true
