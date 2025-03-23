class_name Projectile
extends Node2D

signal arrived

@export var speed: int

var target: Vector2


func _ready() -> void:
	arrived.connect(queue_free)


func _physics_process(delta: float) -> void:
	if not target:
		return

	if global_position.distance_to(target) <= 8.0: # TODO very csöves
		arrived.emit()
	
	global_position += global_position.direction_to(target).normalized() * speed * delta
