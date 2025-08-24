extends CanvasLayer

const ITEM_TRAIT_TOOLTIP = preload("res://scenes/tooltip/item_trait_tooltip.tscn")
const UNIT_TOOLTIP = preload("res://scenes/tooltip/unit_tooltip.tscn")

@onready var popup: GamePopup = %Popup
@onready var popup_2: GamePopup = %Popup2
@onready var timer: Timer = $Timer


func show_timed_popup(message: String, time: float) -> void:
	var already_hidden := false
	var label := Label.new()
	label.text = message
	await popup.show_popup(label, Vector2i.ZERO) # TODO hacky
	TooltipHandler.popup.center()
	timer.wait_time = time
	timer.start()
	popup.hidden.connect(func(): timer.stop(), CONNECT_ONE_SHOT)
	timer.timeout.connect(func():
		if not already_hidden:
			popup.hide_popup()
	, CONNECT_ONE_SHOT)
