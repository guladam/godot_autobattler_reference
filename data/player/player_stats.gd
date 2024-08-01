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
const ROLL_RARITIES := {
	1:  [UnitStats.Rarity.COMMON],
	2:  [UnitStats.Rarity.COMMON],
	3:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON],
	4:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE],
	5:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE],
	6:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE],
	7:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE, UnitStats.Rarity.LEGENDARY],
	8:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE, UnitStats.Rarity.LEGENDARY],
	9:  [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE, UnitStats.Rarity.LEGENDARY],
	10: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE, UnitStats.Rarity.LEGENDARY],
}
const ROLL_CHANCES := {
	1: [1],
	2: [1],
	3: [7.5, 2.5],
	4: [6.5, 3.0, 0.5],
	5: [5.0, 3.5, 1.5],
	6: [4.0, 4.0, 2.0],
	7: [2.75, 4.0, 3.24, 0.1],
	8: [2.5, 3.75, 3.45, 0.3],
	9: [1.75, 2.75, 4.5, 1.0],
	10: [1.0, 2.0, 4.5, 2.5],
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


