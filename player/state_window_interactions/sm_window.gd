extends "res://state_machine.gd"
@onready var resize: Node = $resize
@onready var idle: Node = $idle

func _ready() -> void:
	states_map = {
		"idle": idle,
		"resize": resize,
	}
	EventBus.connect("window_body_entered", _on_window_enter)
	EventBus.connect("window_body_exited", _on_window_exit)


func _change_state(state_name: String) -> void:
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["idle", "resize"]:
		states_stack.push_front(states_map[state_name])

	super._change_state(state_name)

func _on_window_enter(window, body):
	if body != owner:
		return
	print("It's me!")

func _on_window_exit(window, body):
	if body != owner:
		return
	print("it's me again!")


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)
