# meta-name: Item Script with extra Bonus
# meta-description: Apply extra bonuses to BattleUnits, besides a single modifier. 
# meta-default: false
# meta-space-indent: 4
class_name _CLASS_
extends Item


func apply_bonus_effect(battle_unit: BattleUnit) -> void:
	print("This powerful item gives extra bonuses to %s!" % battle_unit)
