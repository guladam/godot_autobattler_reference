@tool
class_name ModifierType
extends Node

@export var owner_node: Node:
	set(value):
		owner_node = value
		notify_property_list_changed()

var owner_property: String:
	set(value):
		owner_property = value
		notify_property_list_changed()

var modified_property: String


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var owner_script: Script = owner_node.get_script()
	
	if not owner_script: 
		return properties
	
	var possible_properties := owner_script.get_script_property_list()
	var property_names = possible_properties.map(func(dict): return dict.get("name"))
	property_names = property_names.slice(1)
	
	var property := {
		"name": "owner_property",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(property_names)
	}
	properties.append(property)
	
	var owner_prop = owner_node.get(owner_property)
	
	if not owner_prop:
		return properties
		
	var owner_property_script: Script = owner_prop.get_script()
	
	if not owner_property_script:
		return properties
	
	var modifier_properties := owner_property_script.get_script_property_list()
	property_names = modifier_properties.map(func(dict): return dict.get("name"))
	property_names = property_names.slice(1)
	
	var modifier_property := {
		"name": "modified_property",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(property_names)
	}
	
	properties.append(modifier_property)
	return properties


func _get(property: StringName):
	if property == "owner_property":
		return owner_property
	if property == "modified_property":
		return modified_property


func _set(property: StringName, value: Variant):
	if property == "owner_property":
		owner_property = value
		return true
	
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
