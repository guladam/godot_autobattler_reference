class_name RingRing
extends Item

const RINGRING_ABILITY := preload("res://scenes/_abilities/ringring_spell.tscn")

func apply_bonus_effect(battle_unit: BattleUnit) -> void:
	print("fireball boom")
	var ability := RINGRING_ABILITY.instantiate() as UnitAbility
	battle_unit.get_tree().root.add_child(ability)
	ability.caster = battle_unit
	ability.use.call_deferred()
