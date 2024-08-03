# STILL TODO!
class_name Traits
extends Control

const TRAIT_UI = preload("res://scenes/trait_ui/trait_ui.tscn")

@export var game_state: GameState
@export var arena_grid: UnitGrid

@onready var trait_container: VBoxContainer = %TraitContainer

var current_traits := {}
var should_update := true


func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)
	arena_grid.unit_grid_changed.connect(_on_arena_grid_changed)
	
	for trait_ui: TraitUI in trait_container.get_children():
		trait_ui.queue_free()


func _update_traits() -> void:
	var traits_to_update := current_traits.keys()
	var active_traits: Array[Trait] = []
	var units := arena_grid.get_all_units()
	var traits := Trait.get_unique_traits_for_units(units)
	
	for trait_data: Trait in traits:
		# Update trait
		if current_traits.has(trait_data):
			var trait_ui := current_traits[trait_data] as TraitUI
			trait_ui.update(units)
			traits_to_update.erase(trait_data)
		# Create new trait
		else:
			_create_trait_ui(trait_data, units)
		# Active traits should be first
		if (current_traits[trait_data] as TraitUI).active:
			active_traits.append(trait_data)
	
	for i in active_traits.size():
		var trait_ui := current_traits[active_traits[i]] as TraitUI
		trait_container.move_child(trait_ui, i)
	
	for orphan_trait: Trait in traits_to_update:
		var trait_ui := current_traits[orphan_trait] as TraitUI
		trait_ui.queue_free()
		current_traits.erase(orphan_trait)


func _create_trait_ui(trait_data: Trait, units: Array[Unit]) -> void:
	var trait_ui := TRAIT_UI.instantiate() as TraitUI
	trait_container.add_child(trait_ui)
	trait_ui.trait_data = trait_data
	trait_ui.update(units)
	current_traits[trait_data] = trait_ui


func _on_arena_grid_changed() -> void:
	if not should_update:
		return
	
	_update_traits()


func _on_game_state_changed() -> void:
	should_update = game_state.current_phase == GameState.Phase.PREPARATION
