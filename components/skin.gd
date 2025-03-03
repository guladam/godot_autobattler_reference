@tool
class_name CustomSkin
extends Sprite2D

@export var stats: UnitStats: set = set_stats


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	texture = UnitStats.TEAM_SPRITESHEET[stats.team]
	region_rect.position = Vector2(stats.skin_coordinates) * Arena.CELL_SIZE
