class_name RerollButton
extends Button

@export var player_stats: PlayerStats

@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	var has_enough_gold := player_stats.gold >= 2
	disabled = not has_enough_gold
	
	if has_enough_gold:
		h_box_container.modulate = Color(Color.WHITE, 1.0)
	else:
		h_box_container.modulate = Color(Color.WHITE, 0.5)


func _on_pressed() -> void:
	player_stats.gold -= 2
