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
