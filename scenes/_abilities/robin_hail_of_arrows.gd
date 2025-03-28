extends UnitAbility


func use() -> void:
	var all_enemies := get_tree().get_nodes_in_group(UnitStats.TARGET[caster.stats.team])
	all_enemies.shuffle()
	for enemy: BattleUnit in all_enemies.slice(0, 3):
		var projectile := caster.ranged_attack.attack(enemy.global_position) as Projectile
		projectile.target = enemy.global_position
		projectile.hitbox.damage = caster.stats.get_attack_damage()

	ability_cast_finished.emit.call_deferred()
