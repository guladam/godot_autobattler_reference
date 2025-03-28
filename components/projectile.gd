class_name Projectile
extends Node2D

@export var speed: int
# TODO could be done like with Area2D with node config
# warnings
@export var hitbox: HitBox
@export var visible_notifier: VisibleOnScreenNotifier2D

var target: Vector2 : set = set_target
var direction: Vector2


func _ready() -> void:
	hitbox.hit.connect(queue_free)
	visible_notifier.screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	if not target:
		return
	
	global_position += direction * speed * delta


func set_target(value: Vector2) -> void:
	target = value
	direction = global_position.direction_to(target).normalized()
