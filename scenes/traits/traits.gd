class_name Traits
extends Control

@onready var trait_container: VBoxContainer = %TraitContainer
@onready var trait_ui_spawner: SceneSpawner = $TraitUISpawner

var current_traits: Dictionary[Trait, TraitUI] = {}
var traits_to_update: Array[Trait]


func _ready() -> void:
	for trait_ui: TraitUI in trait_container.get_children():
		trait_ui.queue_free()


func update_traits(unique_traits: Dictionary[Trait, int], active_traits: Array[Trait]) -> void:
	traits_to_update = current_traits.keys()
	
	for trait_data: Trait in unique_traits:
		var unique_units := unique_traits[trait_data]
		if current_traits.has(trait_data):
			_update_trait_ui(trait_data, unique_units)
		else:
			_create_trait_ui(trait_data, unique_units)
	
	_move_active_traits_to_top(active_traits)
	_delete_orphan_traits()


func _create_trait_ui(trait_data: Trait, unique_units: int) -> void:
	var trait_ui := trait_ui_spawner.spawn_scene(trait_container) as TraitUI
	trait_ui.trait_data = trait_data
	trait_ui.update(unique_units)
	current_traits[trait_data] = trait_ui


func _update_trait_ui(trait_data: Trait, unique_units: int) -> void:
	var trait_ui := current_traits[trait_data] as TraitUI
	trait_ui.update(unique_units)
	traits_to_update.erase(trait_data)


func _move_active_traits_to_top(active_traits: Array[Trait]) -> void:
	var i := 0
	for trait_ui: TraitUI in current_traits.values():
		if active_traits.has(trait_ui.trait_data):
			trait_container.move_child(trait_ui, i)
			i += 1


func _delete_orphan_traits() -> void:
	for orphan_trait: Trait in traits_to_update:
		var trait_ui := current_traits[orphan_trait] as TraitUI
		current_traits.erase(orphan_trait)
		trait_ui.queue_free()
