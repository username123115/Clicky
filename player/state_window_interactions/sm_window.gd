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
	# handle overlapping windows
	if owner.in_window:
		owner.window_stack.push_back(window)	#if this stack is empty this will become the next active window
		return

	owner.in_window = true
	owner.window = window
	print("Transition from open space to a window")

func _on_window_exit(window, body):
	if body != owner:
		return
	if window == owner.window:
		# don't set this to false, find the next window we entered and set that as active
		if len(owner.window_stack):
			owner.window = owner.window_stack.pop_front()
			print("active window has changed")
		# this was the only window, no we're in a plain area
		else:
			owner.in_window = false
			owner.window = null
			print("out in the open!")
	# we exited some window in the window stack, remove it
	else:
		owner.window_stack.erase(window)
			


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)
