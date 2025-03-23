class_name FlipSpriteToDirection
extends Node

@export var sprite: Sprite2D


func flip_sprite_to_dir(other_position: Vector2) -> void:
	var new_dir: Vector2 = sprite.global_position.direction_to(other_position)
	
	if sign(new_dir.x) == 0:
		return
	
	sprite.flip_h = sign(new_dir.x) == 1
