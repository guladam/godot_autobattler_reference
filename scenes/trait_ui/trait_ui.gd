class_name TraitUI
extends PanelContainer

@export var trait_data: Trait : set = _set_trait_data
@export var active: bool : set = _set_active

@onready var trait_icon: TraitIcon = %TraitIcon
@onready var active_units_label: Label = %ActiveUnitsLabel
@onready var trait_level_labels: RichTextLabel = %TraitLevelLabels
@onready var trait_label: Label = %TraitLabel


func _ready() -> void:
	gui_input.connect(_on_gui_input)


func update(unique_units: int) -> void:
	active_units_label.text = str(unique_units)
	trait_level_labels.text = trait_data.get_levels_bbcode(unique_units)
	active = trait_data.is_active(unique_units)


func _set_trait_data(value: Trait) -> void:
	if not is_node_ready():
		await ready

	trait_data = value
	trait_icon.trait_data = trait_data
	trait_label.text = trait_data.name


func _set_active(value: bool) -> void:
	active = value

	if active:
		modulate.a = 1.0
	else:
		modulate.a = 0.5


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("tooltip"):
		TooltipHandler.popup.show_popup(
			trait_icon.icon.texture,
			trait_data.name,
			trait_data.description,
			get_global_mouse_position()
		)
