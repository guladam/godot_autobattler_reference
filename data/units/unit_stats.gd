class_name UnitStats
extends Resource

signal stats_changed

enum Rarity {COMMON, UNCOMMON, RARE}

const RARITY_COLORS := {
	Rarity.COMMON: Color("124a2e"),
	Rarity.UNCOMMON: Color("1c527c"),
	Rarity.RARE: Color("ab0979")
}

@export var name: String

@export_category("Data")
@export var rarity: Rarity 
@export var gold_cost := 1
@export_range(1, 3) var tier := 1 : set = set_tier
@export var pool_count := 15

@export_category("Visuals")
@export var skin_coordinates: Vector2i


func get_gold_value() -> int:
	return gold_cost * 3 ** (tier-1)


func set_tier(value: int) -> void:
	tier = value
	stats_changed.emit()


func _to_string() -> String:
	return name
