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
		_start_chasing()
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


func _start_chasing() -> void:
	target_finder.find_target()
	var chase_state := ChaseState.new(actor)
	chase_state.stuck.connect(_on_chase_state_stuck, CONNECT_ONE_SHOT)
	chase_state.target_reached.connect(_on_chase_state_target_reached, CONNECT_ONE_SHOT)
	fsm.change_state(chase_state)
	# NOTE 
	# this was previously at the end of the chase_state's enter() method
	# BUT we need this here because otherwise the stuck state wouldn't work 
	# because inside the FSM we only set the state to be equal to the new state AFTER we executed enter...
	# and what happened is we wanted to change to stuck on the same frame, before the first change_state() call was concluded
	chase_state.chase()


func _on_chase_state_stuck() -> void:
	var stuck_state := StuckState.new(actor)
	stuck_state.timeout.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(stuck_state)


func _on_chase_state_target_reached() -> void:
	var aa_state := AutoAttackState.new(actor)
	fsm.change_state(aa_state)
