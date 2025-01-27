class_name QuickSell
extends Node

signal quick_sell_pressed

@export var enabled: bool = true
@export var unit: Unit


func _input(event: InputEvent) -> void:
	if not enabled or not unit.is_hovered:
		return

	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()
