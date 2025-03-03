class_name DetectRange
extends Area2D

@export var col_shape: CollisionShape2D
@export var base_range_size: Vector2
@export var stats: UnitStats:
	set(value):
		stats = value
		collision_layer = 4 * (stats.team + 1)
		collision_mask = 2 - stats.team
		
		# TODO is a circle actually better?
		var shape := RectangleShape2D.new()
		shape.size = base_range_size * stats.attack_range
		col_shape.shape = shape
