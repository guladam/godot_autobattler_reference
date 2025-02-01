class_name FiniteStateMachine
extends Node

# NOTE test code
@export var debug_label: Label

var state: State


func change_state(new_state: State) -> void:
	if state:
		state.exit()
	
	if new_state:
		new_state.enter()
		debug_label.text = new_state.get_script().get_global_name()
	
	state = new_state
