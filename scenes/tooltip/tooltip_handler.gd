extends CanvasLayer

const ITEM_TRAIT_TOOLTIP = preload("res://scenes/tooltip/item_trait_tooltip.tscn")
const UNIT_TOOLTIP = preload("res://scenes/tooltip/unit_tooltip.tscn")

@onready var popup: GamePopup = %Popup
@onready var popup_2: GamePopup = %Popup2
