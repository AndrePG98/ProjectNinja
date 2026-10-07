class_name StateMachine extends Node

signal state_changed(prev: States.State, next: States.State)

var state: States.State = States.State.IDLE


func set_state(new_state: States.State) -> void:
	if new_state == state:
		return
	var prev: States.State = state
	state = new_state
	state_changed.emit(prev, new_state)
