extends "state_machine.gd"
@onready var floating: Node = $floating

func _ready() -> void:
	states_map = {
		"floating": floating,
	}


func _change_state(state_name: String) -> void:
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["floating"]:
		states_stack.push_front(states_map[state_name])

	super._change_state(state_name)


func _unhandled_input(event: InputEvent) -> void:
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.

	current_state.handle_input(event)
