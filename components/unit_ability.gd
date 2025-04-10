class_name UnitAbility
extends Node2D

signal ability_cast_finished

@export var caster: BattleUnit

# NOTE show how this can happen when an ability is created but cannot be used 
# for Robin
func _ready() -> void:
	add_to_group("unit_abilities")


func use() -> void:
	ability_cast_finished.emit()
