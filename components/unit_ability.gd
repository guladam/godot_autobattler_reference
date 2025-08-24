class_name UnitAbility
extends Node2D

signal ability_cast_finished

@export var caster: BattleUnit
@export var sound: AudioStream

# NOTE show how this can happen when an ability is created but cannot be used 
# for Robin e.g. when you fill your mana bar as the battle concludes
func _ready() -> void:
	add_to_group("unit_abilities")


func use() -> void:
	SFXPlayer.play(sound)
	ability_cast_finished.emit()
