class_name ChaseState
extends State

signal target_reached(target: BattleUnit)
signal stuck

var actor_unit: BattleUnit
var tween: Tween


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
	
	# nowhere to go this frame so either the unit is stuck or can hit someone in range
	if new_pos == Vector2(-1, -1):
		# we might already have a new target if a unit died or something?
		if actor_unit.target_finder.has_target_in_range():
			target_reached.emit(actor_unit.target_finder.targets_in_range[0])
		else:
			actor_unit.animation_player.play("RESET")
			stuck.emit()
		return
	
	actor_unit.flip_sprite_to_direction.flip_sprite_to_dir(new_pos)
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
