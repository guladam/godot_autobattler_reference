class_name PlayerStats
extends Resource

const XP_REQUIREMENTS := {
	1: 0,
	2: 2,
	3: 2,
	4: 6,
	5: 10,
	6: 20,
	7: 36,
	8: 48,
	9: 76,
	10: 76
}

@export_range(0, 99) var gold: int : set = set_gold
@export_range(0, 99) var xp: int : set = set_xp
@export_range(1, 10) var level: int : set = set_level


func get_current_xp_requirement() -> int:
	return XP_REQUIREMENTS[level+1]


func set_gold(value: int) -> void:
	gold = value
	emit_changed()


func set_xp(value: int) -> void:
	xp = value
	emit_changed()
	
	if level == 10:
		return
	
	var xp_requirement: int = XP_REQUIREMENTS[level+1]
	
	if xp >= xp_requirement:
		level += 1
		xp -= xp_requirement
		emit_changed()


func set_level(value: int) -> void:
	level = value
	emit_changed()
