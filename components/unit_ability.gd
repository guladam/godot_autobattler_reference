class_name UnitAbility
extends Node2D

signal ability_cast_finished

@export var caster: BattleUnit

func use() -> void:
	ability_cast_finished.emit()
