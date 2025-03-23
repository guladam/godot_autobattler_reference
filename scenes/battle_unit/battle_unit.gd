class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var custom_skin: CustomSkin = $CustomSkin
@onready var detect_range: DetectRange = $DetectRange
@onready var attack_smear_anchor: Node2D = $AttackSmearAnchor
@onready var attack_smear_marker: Marker2D = $AttackSmearAnchor/AttackSmearMarker
@onready var health_bar: HealthBar = $HealthBar
@onready var mana_bar: ManaBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var attack_smear_spawner: SceneSpawner = $AttackSmearSpawner
@onready var flip_sprite_to_direction: FlipSpriteToDirection = $FlipSpriteToDirection
@onready var projectile_spawner: SceneSpawner = $ProjectileSpawner
@onready var target_finder: TargetFinder = $TargetFinder
@onready var unit_ai: UnitAI = $UnitAI
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer


# TODO kinda ugly to do it here
# this could be its own component? Might be reusable for spawning projectiles
func spawn_melee_smear(target_position: Vector2) -> void:
	var angle := global_position.direction_to(target_position).angle()
	attack_smear_anchor.rotation = angle
	var smear := attack_smear_spawner.spawn_scene(get_tree().root) as Node2D
	smear.global_position = attack_smear_marker.global_position
	smear.rotation = angle

# TODO yikes bruh
func spawn_projectile(target_position: Vector2) -> Projectile:
	var angle := global_position.direction_to(target_position).angle()
	attack_smear_anchor.rotation = angle
	var projectile := projectile_spawner.spawn_scene(get_tree().root) as Projectile
	projectile.global_position = attack_smear_marker.global_position
	projectile.rotation = angle
	projectile.target = target_position
	
	return projectile


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
	mana_bar.stats = stats
	tier_icon.stats = stats
