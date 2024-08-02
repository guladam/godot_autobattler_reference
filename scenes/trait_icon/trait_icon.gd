class_name TraitIcon
extends TextureRect

# FIXME make setter _ consistent in the project
@export var trait_data: Trait : set = set_trait_data

@onready var icon: TextureRect = $Icon


func set_trait_data(value: Trait) -> void:
	if not is_node_ready():
		await ready

	trait_data = value
	icon.texture = trait_data.icon
