extends Area2D

@onready var drag_and_drop_component: DragAndDrop = $DragAndDropComponent
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation


func _ready() -> void:
	drag_and_drop_component.drag_started.connect(_on_drag_started)
	drag_and_drop_component.drag_canceled.connect(_on_drag_canceled)
	drag_and_drop_component.dropped.connect(_on_dropped)


func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true


func _on_drag_canceled(starting_position: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = starting_position


func _on_dropped(starting_position: Vector2) -> void:
	_on_drag_canceled(starting_position)
