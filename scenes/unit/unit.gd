@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

const TIER_ICONS := {
	1: preload("res://assets/sprites/level1.png"),
	2: preload("res://assets/sprites/level2.png"),
	3: preload("res://assets/sprites/level3.png"),
}

@export var stats: UnitStats : set = set_stats

@onready var skin: Sprite2D = $Visuals/Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var tier_icon: TextureRect = $TierIcon
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

var is_hovered := false


func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)


func _input(event: InputEvent) -> void:
	if not is_hovered:
		return
	
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
	
	# NOTE point this out in the tutorial
	# without duplicate() the tier of units would be shared
	if not Engine.is_editor_hint():
		stats = value.duplicate()
		stats.changed.connect(_on_stats_changed)
	
	if not skin:
		await ready
	
	skin.region_rect.position = Vector2(stats.skin_coordinates * Vector2i(32, 32))


func reset_after_dragging(starting_position: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = starting_position

# NOTE might need to create a separate component for this
func play_combine_animation(target_position: Vector2) -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	health_bar.hide()
	mana_bar.hide()
	tier_icon.hide()
	tween.tween_property(self, "global_position", target_position, UnitCombiner.COMBINE_ANIM_LENGTH)
	tween.parallel().tween_property(self, "scale", Vector2(0.5, 0.5), UnitCombiner.COMBINE_ANIM_LENGTH)
	tween.parallel().tween_property(self, "modulate:a", 0.5, UnitCombiner.COMBINE_ANIM_LENGTH)
	# TODO this unit should be dereferenced in its Grid!
	tween.tween_callback(queue_free)


func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true


func _on_drag_canceled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)


func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	
	is_hovered = true
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	
	is_hovered = false
	outline_highlighter.clear_highlight()
	z_index = 0


func _on_stats_changed() -> void:
	tier_icon.texture = TIER_ICONS[stats.tier]
