class_name Unit
extends Area2D

signal drag_started
signal drag_canceled
signal dropped(starting_position: Vector2)

@onready var visuals: CanvasGroup = $Visuals
@onready var drag_and_drop_component: DragAndDrop = $DragAndDropComponent
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation


func _ready() -> void:
	drag_and_drop_component.drag_started.connect(_on_drag_started)
	drag_and_drop_component.drag_canceled.connect(_on_drag_canceled)
	drag_and_drop_component.dropped.connect(_on_dropped)


func reset_after_dragging(starting_position: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = starting_position


func _clear_highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 0)


func _highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 2)


func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true
	drag_started.emit()


func _on_drag_canceled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)
	drag_canceled.emit()


func _on_dropped(starting_position: Vector2) -> void:
	dropped.emit(starting_position)


func _on_mouse_entered() -> void:
	_highlight()


func _on_mouse_exited() -> void:
	_clear_highlight()
