class_name TargetFinder
extends Node

@export var actor: BattleUnit

var target: BattleUnit


func find_target() -> void:
	var all_targets := actor.get_tree().get_nodes_in_group(UnitStats.TARGET[actor.stats.team])
	var distances := all_targets.map(
		func(target_candidate: BattleUnit) -> float:
			return actor.global_position.distance_squared_to(target_candidate.global_position)
	)
	var idx := distances.find(distances.min())
	
	target = all_targets[idx]
