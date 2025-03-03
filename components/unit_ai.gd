class_name UnitAI
extends Node

@export var enabled: bool: set = set_enabled
@export var actor: BattleUnit
@export var fsm: FiniteStateMachine
@export var target_finder: TargetFinder


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("quick_sell"):
		#enabled = not enabled


func set_enabled(value: bool) -> void:
	enabled = value
	
	if enabled:
		target_finder.find_target()
		fsm.change_state(ChaseState.new(actor))
	else:
		fsm.change_state(null)


func _physics_process(delta: float) -> void:
	if not enabled:
		return

	fsm.state.physics_process(delta)


func _process(delta: float) -> void:
	if not enabled:
		return

	fsm.state.process(delta)


func perform_step() -> void:
	if not enabled:
		return
	
	fsm.state.step()
