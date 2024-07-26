class_name VelocityBasedRotation
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var target: Node2D
@export var rotation_multiplier := 50
@export var x_velocity_threshold := 1.0

var last_position: Vector2
var velocity: Vector2
var angle: float


func _process(delta: float) -> void:
	if not enabled or not target:
		return
	
	velocity = target.global_position - last_position
	last_position = target.global_position
	
	if abs(velocity.x) > x_velocity_threshold:
		angle = velocity.normalized().x * rotation_multiplier * delta
	else:
		angle = 0.0
	
	target.rotation = lerp_angle(target.rotation, angle, 0.7)


func _set_enabled(value: bool) -> void:
	enabled = value
	
	if target and enabled == false:
		target.rotation = 0.0
