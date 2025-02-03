class_name ChaseState
extends State

var in_range := false
var actor_unit: BattleUnit
var target: BattleUnit


func enter() -> void:
	actor_unit = actor as BattleUnit
	target = actor_unit.target_finder.target
	actor_unit.context_based_steering.enabled = true
	actor_unit.area_entered.connect(_on_area_entered)


func exit() -> void:
	actor_unit.area_exited.disconnect(_on_area_entered)


func _on_target_reached() -> void:
	in_range = true
	actor_unit.context_based_steering.enabled = false
	print("%s reached its target!" % actor_unit.name)


func _on_area_entered(area: Area2D) -> void:
	if area:
		_on_target_reached()
