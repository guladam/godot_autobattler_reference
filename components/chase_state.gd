class_name ChaseState
extends State

var in_range := false
var actor_unit: BattleUnit
var target: BattleUnit
var tween: Tween


func enter() -> void:
	actor_unit = actor as BattleUnit
	target = actor_unit.target_finder.target
	actor_unit.area_entered.connect(_on_area_entered)
	_tween_to_next_position()


func physics_process(_delta: float) -> void:
	if tween and tween.is_running():
		return
	
	if in_range:
		return
	
	_tween_to_next_position()


func exit() -> void:
	actor_unit.area_entered.disconnect(_on_area_entered)


func _tween_to_next_position() -> void:
	if tween and tween.is_running():
		return

	# TODO somehow enforce the order of units
	# it kinda works now but only once, when we start the combat
	# then, node order determines it
	# one, hacky solution would be ordering nodes by their prio
	var new_pos: Vector2 = UnitNavigation.get_next_position(actor_unit, target)
	print("%s (%s) " % [actor_unit.name, actor_unit.stats.name], actor_unit.global_position, " --> ", new_pos)
	
	# nowhere to go this frame
	if new_pos == Vector2(-1, -1):
		return
	
	tween = actor_unit.create_tween()
	tween.tween_property(actor_unit, "global_position", new_pos, 3)
	tween.finished.connect(tween.kill)


func _on_target_reached() -> void:
	in_range = true
	print("%s reached its target!" % actor_unit.name)


func _on_area_entered(area: Area2D) -> void:
	if area:
		_on_target_reached()
