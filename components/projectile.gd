@tool
class_name Projectile
extends Node2D

@export var speed: int

@export var hitbox: HitBox : set = set_hitbox
@export var visible_notifier: VisibleOnScreenNotifier2D : set = set_visible_notifier

var target: Vector2 : set = set_target
var direction: Vector2


func _ready() -> void:
	hitbox.hit.connect(queue_free)
	visible_notifier.screen_exited.connect(queue_free)


func _physics_process(delta: float) -> void:
	if not target:
		return
	
	global_position += direction * speed * delta


func _get_configuration_warnings() -> PackedStringArray:
	if not hitbox or not visible_notifier:
		return ["Projectiles need to have HitBox and VisibleOnScreenNotifier2D children nodes!"]
	else:
		return []


func set_hitbox(value: HitBox) -> void:
	hitbox = value
	update_configuration_warnings()


func set_visible_notifier(value: VisibleOnScreenNotifier2D) -> void:
	visible_notifier = value
	update_configuration_warnings()


func set_target(value: Vector2) -> void:
	target = value
	direction = global_position.direction_to(target).normalized()
