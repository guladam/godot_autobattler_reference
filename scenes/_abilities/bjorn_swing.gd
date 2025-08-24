extends UnitAbility

@export var base_damage_per_tier: Array[int]

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func use() -> void:
	hit_box.damage = base_damage_per_tier[caster.stats.tier-1]
	hit_box.damage += caster.stats.ability_power # NOTE this will be important for items

	SFXPlayer.play(sound)
	animation_player.play("swing")
	animation_player.animation_finished.connect(_on_animation_finished.unbind(1))


func _on_animation_finished() -> void:
	ability_cast_finished.emit()
	queue_free()
