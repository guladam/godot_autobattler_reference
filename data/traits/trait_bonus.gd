class_name TraitBonus
extends Node

var trait_data: Trait
var matching_units: Array[Node] # NOTE kinda csöves
var level: int

func _init(_trait: Trait) -> void:
	trait_data = _trait


func _ready() -> void:
	matching_units = get_tree().get_nodes_in_group("player_units").filter(
		func(battle_unit: BattleUnit):
			return battle_unit.stats.traits.has(trait_data)
	)
	level = trait_data.get_reached_level(matching_units.size())
	add_to_group("trait_bonuses")

# TODO might need a script template?
func apply_bonus() -> void:
	print("apply trait bonus at %s!" % level)
