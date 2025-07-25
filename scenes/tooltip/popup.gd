class_name GamePopup
extends PopupPanel

@onready var popup_icon: TextureRect = %PopupIcon
@onready var popup_title: Label = %PopupTitle
@onready var popup_description: RichTextLabel = %PopupDescription

var last_click: InputEvent


func _ready() -> void:
	window_input.connect(_on_window_input)
	popup_hide.connect(
		func():
			get_tree().root.push_input(last_click)
	)
	

func show_popup(icon: Texture, title_text: String, description: String, pos: Vector2i) -> void:
	popup_icon.texture = icon
	popup_title.text = title_text
	popup_description.text = description
	child_controls_changed()
	pos = Vector2i(clampi(pos.x, 0, get_tree().root.size.x), clampi(pos.y, 0, get_tree().root.size.y))
	popup(Rect2i(pos, get_contents_minimum_size()))


func _on_window_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("select") or event.is_action_pressed("tooltip"):
		last_click = event.duplicate()
		hide()
