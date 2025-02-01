class_name ChaseState
extends State

var in_range := false
var actor_unit: BattleUnit


func physics_process(delta: float) -> void:
	var movement_vector := (actor_unit.target_finder.target.global_position - actor_unit.global_position)
	actor_unit.global_position += movement_vector.normalized() * delta * actor_unit.stats.movement_speed


func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.area_entered.connect(_on_area_entered)


func exit() -> void:
	actor_unit.area_exited.disconnect(_on_area_entered)


func _on_area_entered(area: BattleUnit) -> void:
	if area == actor_unit.target_finder.target:
		in_range = true
		print("%s reached its target!" % actor_unit.name)
