class_name AutoAttackState
extends State

signal target_left_range
signal target_died

var in_range := true
var actor_unit: BattleUnit
var target: BattleUnit


func _init(new_actor: Node, current_target: BattleUnit) -> void:
	actor = new_actor
	target = current_target


func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.detect_range.area_exited.connect(_on_detect_range_exited)
	# definitely does not belong here
	actor_unit.attack_timer.wait_time = 1/actor_unit.stats.attack_speed
	actor_unit.attack_timer.timeout.connect(_attack)
	actor_unit.attack_timer.start()


func exit() -> void:
	actor_unit.detect_range.area_exited.disconnect(_on_detect_range_exited)
	actor_unit.attack_timer.stop()
	actor_unit.attack_timer.timeout.disconnect(_attack)


func _attack() -> void:
	actor_unit.animation_player.play("attack")
	actor_unit.animation_player.animation_finished.connect(
		func(_name):
			target.stats.health -= actor_unit.stats.get_attack_damage()
			if target.stats.health <= 0:
				target.queue_free()
				target_died.emit()
	, CONNECT_ONE_SHOT
	)


func _on_detect_range_exited(area: BattleUnit) -> void:
	if area == target:
		in_range = false
		target_left_range.emit()
