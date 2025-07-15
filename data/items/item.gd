class_name Item
extends Resource

@export var name: String
@export var id: StringName
@export_multiline var description: String
@export var component: bool
@export var sprite_coordinates: Vector2i
@export var modifiers: Dictionary[Modifier.Type, ModifierValue]


func apply_modifiers(battle_unit: BattleUnit) -> void:
	for type: Modifier.Type in modifiers.keys():
		var unit_modifier := battle_unit.modifier_handler.get_modifier(type)
		unit_modifier.add_new_value(modifiers[type])

# This is overrode by combined items
func apply_bonus_effect(_battle_unit: BattleUnit) -> void:
	pass


func _to_string() -> String:
	return "Item: %s (%s) | %s" % [name, id, description]
