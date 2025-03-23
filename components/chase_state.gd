class_name ChaseState
extends State

signal target_reached(target: BattleUnit)
signal stuck

var actor_unit: BattleUnit
var tween: Tween

# TODO fix chase state so units won't get stuck randomly
func enter() -> void:
	actor_unit = actor as BattleUnit
	if actor_unit.target_finder.has_target_in_range():
		target_reached.emit.call_deferred(actor_unit.target_finder.targets_in_range[0])
	else:
		actor_unit.target_finder.find_target()
		actor_unit.target_finder.targets_in_range_changed.connect(_on_targets_in_range_changed)


func exit() -> void:
	if actor_unit.target_finder.targets_in_range_changed.is_connected(_on_targets_in_range_changed):
		actor_unit.target_finder.targets_in_range_changed.disconnect(_on_targets_in_range_changed)


func chase() -> void:
	if tween and tween.is_running():
		return

	if actor_unit.target_finder.has_target_in_range():
		return

	actor_unit.target_finder.find_target()
	var new_pos: Vector2 = UnitNavigation.get_next_position(actor_unit, actor_unit.target_finder.target)
	
	# nowhere to go this frame so stop
	if new_pos == Vector2(-1, -1):
		actor_unit.animation_player.play("RESET")
		stuck.emit()
		return
	
	# TODO this might not belong here
	var new_dir: Vector2 = actor_unit.global_position.direction_to(new_pos)
	if sign(new_dir.x) == 1:
		actor_unit.custom_skin.flip_h = true
	if sign(new_dir.x) == -1:
		actor_unit.custom_skin.flip_h = false
	
	tween = actor_unit.create_tween()
	tween.tween_callback(actor_unit.animation_player.play.bind("move"))
	tween.tween_property(actor_unit, "global_position", new_pos, 1.5)
	tween.finished.connect(
		func():
			tween.kill()
			
			if actor_unit.target_finder.has_target_in_range():
				target_reached.emit(actor_unit.target_finder.targets_in_range[0])
			else:
				chase()
	)


func _on_targets_in_range_changed() -> void:
	if not tween and actor_unit.target_finder.has_target_in_range():
		target_reached.emit(actor_unit.target_finder.targets_in_range[0])
