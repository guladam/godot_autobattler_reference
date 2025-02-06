class_name UnitStats
extends Resource

enum Rarity {COMMON, UNCOMMON, RARE, LEGENDARY}
enum Team {PLAYER, ENEMY}

const RARITY_COLORS := {
	Rarity.COMMON: Color("124a2e"),
	Rarity.UNCOMMON: Color("1c527c"),
	Rarity.RARE: Color("ab0979"),
	Rarity.LEGENDARY: Color("ea940b"),
}

const TARGET := {
	Team.PLAYER: "enemy_units",
	Team.ENEMY: "player_units"
}

const MAX_ATTACK_RANGE := 5

@export var name: String
@export_range(1, 3) var tier := 1 : set = set_tier
@export var traits: Array[Trait]

@export_category("Shop")
@export var rarity: Rarity 
@export var gold_cost := 1
@export var pool_count := 15

@export_category("Visuals")
@export var skin_coordinates: Vector2i

@export_category("Battle")
@export var team: Team
@export var max_health: Array[int]
@export var max_mana: int
@export var starting_mana: int
@export var attack_damage: Array[int]
@export var ability_power: int
@export var attack_speed: float
@export var armor: int
@export var magic_resist: int
@export_range(1, MAX_ATTACK_RANGE) var attack_range: int: set = set_attack_range

var health: int
var mana: int
var movement_priority: int


func get_combined_unit_count() -> int:
	return 3 ** (tier-1)


func get_gold_value() -> int:
	return gold_cost * get_combined_unit_count()


func get_trait_names() -> PackedStringArray:
	var trait_names: PackedStringArray = []
	
	for current_trait in traits:
		trait_names.append(current_trait.name)
		
	return trait_names


func set_tier(value: int) -> void:
	tier = value
	changed.emit()


func set_attack_range(value: int) -> void:
	attack_range = value
	movement_priority = MAX_ATTACK_RANGE - attack_range


func _to_string() -> String:
	return name
