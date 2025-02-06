class_name ContextBasedSteering
extends Node

@export var battle_unit: BattleUnit
@export var enabled := false
@export var steer_force := 0.25
@export var look_ahead := 32
@export var rays := 16

var ray_directions: Array[Vector2] = []
var interest: Array[float] = []
var danger: Array[float] = []

# Note: https://andrewfray.wordpress.com/2013/03/26/context-behaviours-know-how-to-share/
# Possible algorithm fix
# make rays bigger
# interest: find all enemies, fill in interest based on distance
# danger: find all nearby colliding rays, fill in danger based on distance

# or ignore this solution and go with the reddit thread
# or with gemini

func _ready() -> void:
	interest.resize(rays)
	danger.resize(rays)
	ray_directions.resize(rays)
	
	for i: int in rays:
		var angle := i * 2 * PI / rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	_set_interest()
	_set_danger()
	var desired_velocity := _choose_direction() * battle_unit.stats.movement_speed * delta
	battle_unit.global_position += Vector2.ZERO.lerp(desired_velocity, steer_force)


func _set_interest() -> void:
	if battle_unit.target_finder.target:
		var direction = battle_unit.global_position.direction_to(battle_unit.target_finder.target.global_position)
		for i: int in rays:
			var dot_prod := ray_directions[i].dot(direction)
			interest[i] = max(0, dot_prod)
	else:
		_set_default_interest()


func _set_default_interest() -> void:
	for i in rays:
		var dot_prod = ray_directions[i].dot(battle_unit.transform.x)
		interest[i] = max(0, dot_prod)


func _set_danger() -> void:
	var space_state := battle_unit.get_world_2d().direct_space_state
	for i: int in rays:
		var query := PhysicsRayQueryParameters2D.create(
			battle_unit.global_position,
			battle_unit.global_position + ray_directions[i] * look_ahead,
			battle_unit.stats.team + 1,
			[battle_unit.get_rid()]
		)
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result := space_state.intersect_ray(query)
		danger[i] = 1.0 if result else 0.0


func _choose_direction() -> Vector2:
	var chosen_dir := Vector2.ZERO
	
	for i: int in rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	
	for i: int in rays:
		chosen_dir += ray_directions[i] * interest[i]
	
	return chosen_dir.normalized()
