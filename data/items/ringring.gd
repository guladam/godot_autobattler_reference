class_name RingRing
extends Item

const RINGRING_ABILITY := preload("res://scenes/_abilities/ringring_spell.tscn")

func apply_bonus_effect(battle_unit: BattleUnit) -> void:
	var ability := RINGRING_ABILITY.instantiate() as UnitAbility
	battle_unit.get_tree().root.add_child(ability)
	ability.caster = battle_unit
	ability.ability_cast_finished.connect(ability.queue_free)
	ability.use.call_deferred()
