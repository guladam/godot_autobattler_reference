class_name SellPortal
extends Area2D

@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

var current_unit: Unit

func _ready() -> void:
	# TODO do the same when a new unit is added
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		unit.dropped.connect(_on_unit_dropped.bind(unit))


func _on_unit_dropped(_starting_position: Vector2, unit: Unit) -> void:
	if unit and unit == current_unit:
		print("unit sold!") # TODO generate money, give items back
		current_unit.queue_free()


func _on_area_entered(unit: Unit) -> void:
	current_unit = unit
	outline_highlighter.highlight()


func _on_area_exited(unit: Unit) -> void:
	if unit and unit == current_unit:
		current_unit = null
	
	outline_highlighter.clear_highlight()
