class_name SceneSpawner
extends Node

@export var scene: PackedScene


# TODO this component could be reused by other components which spawn things :)
func spawn_scene(parent: Node = owner) -> Node:
	var new_scene := scene.instantiate()
	parent.add_child(new_scene)
	
	return new_scene
