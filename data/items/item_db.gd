class_name ItemDB
extends Resource

@export var recipes: Array[ItemRecipe]


func combine_item_components(items: Array[Item], equipped_item: Item) -> ItemRecipe:
	var components := _get_component_items(items)
	
	if not equipped_item.component or components.is_empty():
		return null
	
	return _get_recipe_from_components(components[0], equipped_item)


func _get_component_items(items: Array[Item]) -> Array[Item]:
	return items.filter(
		func(item: Item) -> bool:
			if not item: return false
			return item.component
	)


func _get_recipe_from_components(item1: Item, item2: Item) -> ItemRecipe:
	for recipe: ItemRecipe in recipes:
		if recipe.can_be_combined(item1, item2):
			return recipe
	
	return null
