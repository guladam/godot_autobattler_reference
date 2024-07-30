class_name ShopUnitCard
extends Control

signal unit_bought(unit: UnitStats)

const HOVER_BORDER_COLOR := Color("fafa82")

@export var unit_stats: UnitStats : set = set_unit_stats

@onready var traits: Label = %Traits
@onready var bottom: Panel = %Bottom
@onready var unit_name: Label = %UnitName
@onready var gold_cost: Label = %GoldCost
@onready var border: Panel = %Border
@onready var empty_placeholder: Panel = %EmptyPlaceholder
@onready var unit_icon: TextureRect = %UnitIcon
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")
@onready var bottom_sb: StyleBoxFlat = bottom.get_theme_stylebox("panel")

var bought := false
var border_color: Color


func set_unit_stats(value: UnitStats) -> void:
	if not is_node_ready():
		await ready

	unit_stats = value
	border_color = UnitStats.RARITY_COLORS[unit_stats.rarity]
	border_sb.border_color = border_color
	bottom_sb.bg_color = border_color
	unit_name.text = unit_stats.name
	gold_cost.text = str(unit_stats.gold_cost)
	unit_icon.texture.region.position = Vector2(unit_stats.skin_coordinates * Vector2i(32, 32)) # FIXME ugly code plus redundant


func _on_mouse_entered() -> void:
	border_sb.border_color = HOVER_BORDER_COLOR


func _on_mouse_exited() -> void:
	border_sb.border_color = border_color


func _on_gui_input(event: InputEvent) -> void:
	if bought:
		return

	if event.is_action_pressed("select"):
		bought = true
		empty_placeholder.show()
		print("subtract gold...")
		unit_bought.emit(unit_stats)
