class_name ItemTraitTooltip
extends VBoxContainer

@onready var popup_icon: TextureRect = %PopupIcon
@onready var popup_title: Label = %PopupTitle
@onready var popup_description: RichTextLabel = %PopupDescription

var tooltip_data: ItemTraitTooltipData


func _ready() -> void:
	if not tooltip_data:
		return

	popup_icon.texture = tooltip_data.texture
	popup_title.text = tooltip_data.title
	popup_description.text = tooltip_data.description
	popup_description.custom_minimum_size.x = tooltip_data.min_size_x


func setup(data: ItemTraitTooltipData, min_x: float = 0.0) -> void:
	tooltip_data = data
	tooltip_data.min_size_x = min_x


class ItemTraitTooltipData:
	var texture: Texture
	var title: String
	var description: String
	var min_size_x: float
