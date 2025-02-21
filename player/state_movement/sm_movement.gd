extends "res://state_machine.gd"
@onready var floating: Node = $Floating
@onready var idle: Node = $Idle
@onready var falling: Node = $Falling

var should_float = true;

func _ready() -> void:
	states_map = {
		"floating": floating,
		"falling": falling,
		"idle": idle,
	}


func _change_state(state_name: String) -> void:
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["floating"]:
		states_stack.push_front(states_map[state_name])

	if state_name == "idle":
		states_stack = ["idle"]

	super._change_state(state_name)


func _unhandled_input(event: InputEvent) -> void:
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	if Input.is_action_just_pressed("debug_switch_float"):
		should_float = not should_float
		if should_float:
			_change_state('floating')
		else:
			_change_state('falling')
		owner.enable_border_collisions(not should_float);

	current_state.handle_input(event)
