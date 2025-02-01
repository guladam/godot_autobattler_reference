class_name SearchTargetState
extends State


func enter() -> void:
	var actor_unit := actor as BattleUnit
	var all_targets := actor.get_tree().get_nodes_in_group(UnitStats.TARGET[actor_unit.stats.team])
	var distances := all_targets.map(
		func(target: BattleUnit) -> float:
			return actor_unit.global_position.distance_squared_to(target.global_position)
	)
	var idx := distances.find(distances.min())
	print("%s targets: %s" % [actor_unit.name, all_targets[idx].name])
