class_name TraitUI
extends PanelContainer

@export var trait_data: Trait : set = set_trait_data
@export var active: bool : set = set_active

@onready var trait_icon: TraitIcon = %TraitIcon
@onready var active_units_label: Label = %ActiveUnitsLabel
@onready var trait_level_labels: RichTextLabel = %TraitLevelLabels
@onready var trait_label: Label = %TraitLabel


func set_trait_data(value: Trait) -> void:
	if not is_node_ready():
		await ready

	trait_data = value
	trait_icon.trait_data = trait_data
	trait_label.text = trait_data.name


func update(units: Array[UnitStats]) -> void:
	var unique_units := trait_data.get_unique_unit_count(units)
	active_units_label.text = str(unique_units)
	trait_level_labels.text = trait_data.get_levels_bbcode(unique_units)
	active = trait_data.is_active(unique_units)


func set_active(value: bool) -> void:
	active = value

	if active:
		modulate.a = 1.0
	else:
		modulate.a = 0.5
