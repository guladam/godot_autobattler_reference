class_name ChaseState
extends State

signal target_reached
signal stuck

var in_range := false
var actor_unit: BattleUnit
var tween: Tween


func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.target_finder.find_target()
	actor_unit.detect_range.area_entered.connect(_on_area_entered)


func exit() -> void:
	actor_unit.detect_range.area_entered.disconnect(_on_area_entered)


func chase() -> void:
	if tween and tween.is_running():
		return

	if in_range:
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
			actor_unit.animation_player.play("RESET")
			
			if in_range:
				target_reached.emit()
			else:
				chase()
	)


func _on_target_reached() -> void:
	in_range = true


func _on_area_entered(_area: Area2D) -> void:
	_on_target_reached()
