class_name ChaseState
extends State

var in_range := false
var actor_unit: BattleUnit


func physics_process(delta: float) -> void:
	var target := actor_unit.target_finder.target
	
	if not target or target.is_queued_for_deletion():
		_on_target_reached()
		return

	var movement_vector := (target.global_position - actor_unit.global_position)
	actor_unit.global_position += movement_vector.normalized() * delta * actor_unit.stats.movement_speed


func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.area_entered.connect(_on_area_entered)


func exit() -> void:
	actor_unit.area_exited.disconnect(_on_area_entered)


func _on_target_reached() -> void:
	in_range = true
	print("%s reached its target!" % actor_unit.name)


func _on_area_entered(area: BattleUnit) -> void:
	if area == actor_unit.target_finder.target:
		_on_target_reached()
