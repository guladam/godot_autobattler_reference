class_name BattleUnitAttack
extends Node

@export var battle_unit: BattleUnit
@export var anchor: Node2D
@export var spawn_point: Node2D
@export var spawner: SceneSpawner


func attack(target: Vector2) -> Node2D:
	var angle := battle_unit.global_position.direction_to(target).angle()
	anchor.rotation = angle
	var attack_scene := spawner.spawn_scene(get_tree().root) as Node2D
	attack_scene.global_position = spawn_point.global_position
	attack_scene.rotation = angle 
	
	return attack_scene
