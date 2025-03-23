class_name UnitStats
extends Resource

signal mana_bar_filled

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

const TEAM_SPRITESHEET := {
	Team.PLAYER: preload("res://assets/sprites/rogues.png"),
	Team.ENEMY: preload("res://assets/sprites/monsters.png")
}

const MAX_ATTACK_RANGE := 5
const MANA_PER_ATTACK := 10

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
@export_range(1, MAX_ATTACK_RANGE) var attack_range: int

var health: int : set = set_health
var mana: int : set = set_mana


func reset_health() -> void:
	health = get_max_health()


func reset_mana() -> void:
	mana = starting_mana


func get_combined_unit_count() -> int:
	return 3 ** (tier-1)


func get_gold_value() -> int:
	return gold_cost * get_combined_unit_count()


func get_trait_names() -> PackedStringArray:
	var trait_names: PackedStringArray = []
	
	for current_trait in traits:
		trait_names.append(current_trait.name)
		
	return trait_names


func get_max_health() -> int:
	return max_health[tier-1]


func get_attack_damage() -> int:
	return attack_damage[tier-1]


func set_tier(value: int) -> void:
	tier = value
	changed.emit()


func set_health(value: int) -> void:
	health = value
	changed.emit()


func set_mana(value: int) -> void:
	mana = value
	changed.emit()
	
	if mana >= max_mana and max_mana > 0:
		mana_bar_filled.emit()


func _to_string() -> String:
	return name
