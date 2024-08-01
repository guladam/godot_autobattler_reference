class_name XPButton
extends Button

@export var player_stats: PlayerStats

@onready var v_box_container: VBoxContainer = $VBoxContainer


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	var has_enough_gold := player_stats.gold >= 4
	var level_10 := player_stats.level == 10
	disabled = not has_enough_gold or level_10
	
	if has_enough_gold and not level_10:
		v_box_container.modulate = Color(Color.WHITE, 1.0)
	else:
		v_box_container.modulate = Color(Color.WHITE, 0.5)


func _on_pressed() -> void:
	player_stats.gold -= 4
	player_stats.xp += 4
