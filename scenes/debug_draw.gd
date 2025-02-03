extends Node2D

@export var cbs: ContextBasedSteering


func _draw() -> void:
	if not cbs.enabled:
		return

	for i in cbs.rays:
		var mul = 1.0 if cbs.danger[i] > 0.0 else cbs.interest[i]
		var color = Color.RED if cbs.danger[i] > 0.0 else Color.GREEN
		draw_line(position, position + cbs.ray_directions[i] * cbs.look_ahead * mul, color, 1)


func _physics_process(_delta: float) -> void:
	queue_redraw()
