class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var custom_skin: CustomSkin = $CustomSkin
@onready var detect_range: DetectRange = $DetectRange
@onready var hurt_box: HurtBox = $HurtBox
@onready var weapon_anchor: Node2D = $WeaponAnchor
@onready var weapon_marker: Marker2D = $WeaponAnchor/WeaponMarker

@onready var health_bar: HealthBar = $HealthBar
@onready var mana_bar: ManaBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon

@onready var ability_spawner: SceneSpawner = $AbilitySpawner
@onready var flip_sprite_to_direction: FlipSpriteToDirection = $FlipSpriteToDirection
@onready var melee_attack: BattleUnitAttack = $MeleeAttack
@onready var ranged_attack: BattleUnitAttack = $RangedAttack
@onready var target_finder: TargetFinder = $TargetFinder
@onready var unit_ai: UnitAI = $UnitAI
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer


func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)


func set_stats(value: UnitStats) -> void:
	stats = value.duplicate()
	
	if not is_node_ready():
		await ready
	
	# NOTE this is needed for the detect range areas
	collision_layer = stats.team + 1
	hurt_box.collision_layer = stats.team + 1
	hurt_box.collision_mask = 2 - stats.team
	
	ability_spawner.scene = stats.ability
	melee_attack.spawner.scene = stats.melee_attack
	ranged_attack.spawner.scene = stats.ranged_attack
	
	detect_range.stats = stats
	custom_skin.stats = stats
	health_bar.stats = stats
	mana_bar.stats = stats
	tier_icon.stats = stats
	stats.health_reached_zero.connect(queue_free)


func _on_hurt(damage: int) -> void:
	stats.health -= damage
