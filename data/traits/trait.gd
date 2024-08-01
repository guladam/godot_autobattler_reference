class_name Trait
extends Resource

@export var name: String
@export var icon: Texture
@export_multiline var description: String

@export_range(1, 5) var levels: int
@export var unit_requirements: Array[int]
@export var unit_modifiers: Array[PackedScene]


func get_unique_unit_count(units: Array[UnitStats]) -> int:
	units = units.filter(
		func(unit: UnitStats):
			return unit.traits.has(self)
	)
	
	print("before removing duplicates: ", units)
	var unique_units: Array[String] = []
	
	for unit: UnitStats in units:
		if not unique_units.has(unit.name):
			unique_units.append(unit.name)
			
	print("no duplicates: ", unique_units)
	
	return unique_units.size()


func get_levels_bbcode(unit_count: int) -> String:
	var code: PackedStringArray = []
	var reached_level := unit_requirements.filter(
		func(requirement: int):
			return unit_count >= requirement
	)
	
	for i: int in levels:
		if i == (reached_level.size()-1):
			code.append("[color=#fafa82]%s[/color]" % unit_requirements[i])
		else:
			code.append(str(unit_requirements[i]))
		
	return "/".join(code)
