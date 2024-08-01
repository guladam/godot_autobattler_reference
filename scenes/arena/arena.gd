class_name Arena
extends Node2D

@onready var sell_portal: SellPortal = $SellPortal
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_adder: UnitAdder = $UnitAdder
@onready var unit_combiner: UnitCombiner = $UnitCombiner
@onready var shop: Shop = %Shop


func _ready() -> void:
	unit_adder.unit_added.connect(sell_portal.setup_unit)
	unit_adder.unit_added.connect(unit_mover.setup_unit)
	unit_adder.unit_added.connect(unit_combiner.queue_unit_combination_update.unbind(1))
	shop.unit_bought.connect(unit_adder.add_unit)


# FIXME rand_weighted will be added in Godot 4.3 
# so this won't be needed
static func get_random_rarity_for_level(level: int) -> int:
	var weight_sum := 0.0
	for weight in PlayerStats.ROLL_CHANCES[level]:
		weight_sum += weight
	
	var dist := randf() * weight_sum
	for i in PlayerStats.ROLL_CHANCES[level].size():
		dist -= PlayerStats.ROLL_CHANCES[level][i]
		if dist < 0:
			return PlayerStats.ROLL_RARITIES[level][i]
			
	return -1
