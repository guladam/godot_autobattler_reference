class_name Unit
extends Area2D

@export var stats: UnitStats : set = set_stats

@onready var skin: CustomSkin = $Visuals/Skin
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_bar: HealthBar = $HealthBar
@onready var mana_bar: ManaBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var animations: UnitAnimations = $Animations
@onready var quick_sell: QuickSell = $QuickSell

var is_hovered := false


func _ready() -> void:
	drag_and_drop.drag_started.connect(_on_drag_started)
	drag_and_drop.drag_canceled.connect(_on_drag_canceled)


func disable_collision(value: bool) -> void:
	collision_shape_2d.set_deferred("disabled", value)


func set_stats(value: UnitStats) -> void:
	stats = value.duplicate()
	
	if not is_node_ready():
		await ready
	
	skin.stats = stats
	tier_icon.stats = stats
	mana_bar.stats = stats
	stats.reset_mana()


func reset_after_dragging(starting_position: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = starting_position


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
