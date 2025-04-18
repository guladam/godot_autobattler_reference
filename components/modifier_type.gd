@tool
class_name ModifierType
extends Node

const script_pool := {
	"UnitStats": preload("uid://qtb5h4gbrm1s"),
	"Projectile": preload("uid://cfjvvctujfttw")
}

var modified_property: String


func _get_property_list() -> Array[Dictionary]:
	var property_names: PackedStringArray = []
	for current_class: String in script_pool.keys():
		var possible_properties = script_pool[current_class].get_script_property_list()
		property_names.append_array(possible_properties.map(
			func(dict): return current_class + "/" + dict.get("name")
		).slice(1))
	
	var property := {
		"name": "modified_property",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(property_names)
	}
	
	return [property]


func _get(property: StringName):
	if property == "modified_property":
		return modified_property


func _set(property: StringName, value: Variant):
	if property == "modified_property":
		modified_property = value
		return true
	
	return false


func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source == source:
			return value
		
	return null


func add_new_value(value: ModifierValue) -> void:
	var modifier_value := get_value(value.source)
	if not modifier_value:
		add_child(value)
	else:
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value


func remove_value(source: String) -> void:
	for value: ModifierValue in get_children():
		if value.source == source:
			value.queue_free()


func clear_values() -> void:
	for value: ModifierValue in get_children():
		value.queue_free()


func get_modified_value(base: int) -> int:
	var flat_result: int = base
	var percent_result: float = 1.0
	# Apply flat modifiers first
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.FLAT:
			flat_result += value.flat_value
	
	# Apply % modifiers next
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.PERCENT_BASED:
			percent_result += value.percent_value
			
	return floori(flat_result * percent_result)
