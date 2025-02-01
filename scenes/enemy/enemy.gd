class_name Enemy
extends Area2D

@export var enemy_stats: UnitStats: set = set_stats

@onready var custom_skin: CustomSkin = $CustomSkin
@onready var tier_icon: TierIcon = $TierIcon


func set_stats(value: UnitStats) -> void:
	enemy_stats = value.duplicate()
	
	if not is_node_ready():
		await ready
	
	custom_skin.stats = enemy_stats
	tier_icon.stats = enemy_stats
