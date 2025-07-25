@tool
class_name BenchItem
extends Area2D

@export var item: Item : set = _set_item

@onready var packed_sprite_2d: PackedSprite2D = $PackedSprite2D
@onready var drag_and_drop: DragAndDrop = $DragAndDrop

var hovered_unit: Area2D


func _ready() -> void:
	input_event.connect(_on_input_event)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	drag_and_drop.drag_canceled.connect(_on_drag_canceled)
	drag_and_drop.dropped.connect(_on_dropped)
	# item = item # NOTE test code


func _set_item(new_item: Item) -> void:
	item = new_item
	
	if new_item == null or not is_instance_valid(drag_and_drop):
		return
	
	packed_sprite_2d.coordinates = item.sprite_coordinates


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("tooltip"):
		TooltipHandler.popup.show_popup(
			packed_sprite_2d.get_texture_as_atlas(),
			item.name,
			item.description,
			get_global_mouse_position()
		)


func _on_area_entered(area: Area2D) -> void:
	if area is Unit or area is BattleUnit:
		hovered_unit = area


func _on_area_exited(_area: Area2D) -> void:
	hovered_unit = null


func _on_drag_canceled(starting_position: Vector2) -> void:
	global_position = starting_position


func _on_dropped(starting_position: Vector2) -> void:
	if not hovered_unit or not hovered_unit.item_handler:
		global_position = starting_position
	elif hovered_unit.item_handler.add_item(item):
		queue_free()
	else:
		global_position = starting_position
