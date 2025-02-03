extends Node2D

@export var cbs: ContextBasedSteering


func _ready() -> void:
	Engine.time_scale = 0.05


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().get_first_node_in_group("player_units").get_node("DebugDraw").visible = true


func _draw() -> void:
	if not cbs.enabled:
		return

	for i in cbs.rays:
		var mul = 1.0 if cbs.danger[i] > 0.0 else cbs.interest[i]
		var color = Color.RED if cbs.danger[i] > 0.0 else Color.GREEN
		draw_line(position, position + cbs.ray_directions[i] * cbs.look_ahead * mul, color, 1)


func _physics_process(_delta: float) -> void:
	queue_redraw()
