class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var custom_skin: CustomSkin = $CustomSkin
@onready var tier_icon: TierIcon = $TierIcon
@onready var unit_ai: UnitAI = $UnitAI


func set_stats(value: UnitStats) -> void:
	stats = value.duplicate()
	
	if not is_node_ready():
		await ready
	
	custom_skin.stats = stats
	tier_icon.stats = stats
