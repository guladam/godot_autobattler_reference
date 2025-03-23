class_name CastState
extends State

signal ability_cast_finished

var actor_unit: BattleUnit


func enter() -> void:
	print("unit should cast their ability!")
	actor_unit = actor as BattleUnit
	#actor_unit.stats.mana -= actor_unit.stats.max_mana
	# TODO should come from the ability itself
	ability_cast_finished.emit.call_deferred()


func exit() -> void:
	actor_unit.stats.mana -= actor_unit.stats.max_mana
