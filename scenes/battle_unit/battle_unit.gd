class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var custom_skin: CustomSkin = $CustomSkin
@onready var detect_range: DetectRange = $DetectRange
@onready var health_bar: HealthBar = $HealthBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var target_finder: TargetFinder = $TargetFinder
@onready var unit_ai: UnitAI = $UnitAI
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer


func set_stats(value: UnitStats) -> void:
	stats = value.duplicate()
	
	if not is_node_ready():
		await ready
	
	collision_layer = stats.team + 1
	# TODO is this even needed?
	collision_mask = 2 - stats.team
	detect_range.stats = stats
	custom_skin.stats = stats
	health_bar.stats = stats
	tier_icon.stats = stats
