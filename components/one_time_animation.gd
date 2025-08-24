class_name OneTimeAnimation
extends Node

@export var animation_player: AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(animation_player.owner.queue_free.unbind(1))
