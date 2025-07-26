class_name GamePopup
extends PanelContainer

@onready var content_container: MarginContainer = %ContentContainer


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("select") or event.is_action_pressed("tooltip"):
		hide_popup()


func _clear() -> void:
	for node: Control in content_container.get_children():
		node.queue_free()


func _get_position(mouse_pos: Vector2i) -> Vector2i:
	var screen_size := get_tree().root.get_visible_rect().size
	var combined_coords := mouse_pos + Vector2i(size)
	var final_pos := mouse_pos
	if combined_coords.x < 0:
		final_pos.x = 0
	if combined_coords.y < 0:
		final_pos.y = 0
	if combined_coords.x > screen_size.x:
		final_pos.x -= combined_coords.x - screen_size.x
	if combined_coords.y > screen_size.y:
		final_pos.y -= combined_coords.y - screen_size.y

	return final_pos


func show_popup(content: Control, pos: Vector2i) -> void:
	_clear()
	content_container.add_child(content)
	reset_size()
	print(size)
	global_position = _get_position(pos)
	mouse_filter = Control.MOUSE_FILTER_STOP
	show()


func hide_popup() -> void:
	_clear()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide()
