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
	actor_unit.attack_timer.wait_time = _get_auto_attack_speed()
	actor_unit.attack_timer.timeout.connect(_attack)
	actor_unit.attack_timer.start()
	actor_unit.animation_player.play("RESET")


func exit() -> void:
	actor_unit.detect_range.area_exited.disconnect(_on_detect_range_exited)
	actor_unit.attack_timer.stop()
	actor_unit.attack_timer.timeout.disconnect(_attack)


func _get_auto_attack_speed() -> float:
	var base := actor_unit.stats.get_time_between_attacks()
	var modifier := actor_unit.modifier_handler.get_modifier(Modifier.Type.UNIT_ATKSPEED)
	return modifier.get_modified_value(base)


func _get_attack_damage() -> int:
	var base := actor_unit.stats.get_attack_damage()
	var modifier := actor_unit.modifier_handler.get_modifier(Modifier.Type.UNIT_AD)
	return floori(modifier.get_modified_value(base))


func _attack() -> void:
	actor_unit.flip_sprite_to_direction.flip_sprite_to_dir(target.global_position)
	actor_unit.animation_player.play("attack")
	SFXPlayer.play(actor_unit.stats.auto_attack_sound)
	
	if actor_unit.stats.is_melee():
		var hitbox := actor_unit.melee_attack.attack(target.global_position) as HitBox
		hitbox.damage = _get_attack_damage()
		actor_unit.animation_player.animation_finished.connect(_on_attack_hit.unbind(1), CONNECT_ONE_SHOT)
	else:
		var projectile := actor_unit.ranged_attack.attack(target.global_position) as Projectile
		projectile.target = target.global_position
		projectile.hitbox.damage = _get_attack_damage()
		projectile.hitbox.hit.connect(_on_attack_hit)


func _on_attack_hit() -> void:
	if not target:
		return
	
	actor_unit.stats.mana += UnitStats.MANA_PER_ATTACK
	if target.stats.health <= 0:
		target_died.emit()


func _on_detect_range_exited(area: Area2D) -> void:
	if area is BattleUnit and area == target:
		in_range = false
		target_left_range.emit()
