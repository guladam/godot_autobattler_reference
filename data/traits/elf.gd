extends TraitBonus

const ATK_SPEED_BONUS_PERCENTAGE: Array[float] = [
	-0.15,
	-0.3
]


func apply_bonus() -> void:
	for unit: BattleUnit in matching_units:
		var atk_speed_modifier := unit.modifier_handler.get_modifier(Modifier.Type.UNIT_ATKSPEED)
		var modifier_value := ModifierValue.create_new_modifier("elf_trait", ModifierValue.Type.PERCENT_BASED)
		modifier_value.percent_value = ATK_SPEED_BONUS_PERCENTAGE[level]
		atk_speed_modifier.add_new_value(modifier_value)
