class_name AutoAttackState
extends State

signal target_left_range
signal target_died

var in_range := true
var actor_unit: BattleUnit
var target: BattleUnit


# TODO next 
# - provide a barebones framework for abilities, and create a couple ones to test
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
	actor_unit.flip_sprite_to_direction.flip_sprite_to_dir(target.global_position)
	actor_unit.animation_player.play("attack")
	
	if actor_unit.stats.is_melee():
		actor_unit.spawn_melee_smear(target.global_position)
		actor_unit.animation_player.animation_finished.connect(_perform_attack.unbind(1), CONNECT_ONE_SHOT)
	else:
		var projectile := actor_unit.spawn_projectile(target.global_position)
		projectile.arrived.connect(_perform_attack)


func _perform_attack() -> void:
	if not target:
		return
	
	target.stats.health -= actor_unit.stats.get_attack_damage()
	actor_unit.stats.mana += UnitStats.MANA_PER_ATTACK
	if target.stats.health <= 0:
		target.queue_free() # TODO this shouldn't be handled here, should be part of the battle_unit class
		target_died.emit()


func _on_detect_range_exited(area: BattleUnit) -> void:
	if area == target:
		in_range = false
		target_left_range.emit()
