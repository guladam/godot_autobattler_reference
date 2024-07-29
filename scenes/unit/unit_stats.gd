class_name UnitStats
extends Resource

signal stats_changed

@export var name: String
@export_range(1, 3) var tier := 1 : set = set_tier


func set_tier(value: int) -> void:
	tier = value
	stats_changed.emit()
