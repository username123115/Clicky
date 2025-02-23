extends "res://state_machine.gd"
@onready var resize: Node = $Resize
@onready var idle: Node = $Idle
@onready var inside: Node = $Inside
@onready var moving: Node = $Moving

var window_list : Array[GameWin] = []

func _ready() -> void:
	states_map = {
		"idle": idle,
		"inside": inside,
		"resize": resize,
		"moving": moving,
	}
	EventBus.connect("window_body_entered", _on_window_enter)
	EventBus.connect("window_body_exited", _on_window_exit)


func _change_state(state_name: String) -> void:
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["resize", "inside", "moving"]:
		states_stack.push_front(states_map[state_name])
	if state_name == "idle":
		states_stack = ["idle"]

	super._change_state(state_name)
	#print(states_stack)

func _on_window_enter(window, body):
	if body != owner:
		return
	# handle overlapping windows
	if owner.in_window:
		if window.order > owner.window.order:
			print('err what the skibidi sigma rizzler')
			owner.window_stack.push_back(owner.window)
			owner.window_stack.erase(window)
			owner.window = window
			return

		else:
			owner.window_stack.push_back(window)	#if this stack is empty this will become the next active window
			return

	#window.focus(owner)	#focus on resize or move instead
	owner.in_window = true
	owner.window = window
	_change_state("inside")

	#print("Transition from open space to a window")

func _on_window_exit(window, body):
	if body != owner:
		return
	if window == owner.window:
		window.unfocus(owner)
		# don't set this to false, find the next window we entered and set that as active

		if len(owner.window_stack):
			var highest_order : int = -1
			var highest_window : GameWin

			for w in owner.window_stack:
				if w.order > highest_order:
					highest_window = w
					highest_order = w.order

			owner.window_stack.erase(highest_window)
			owner.window = highest_window
			#owner.window = owner.window_stack.pop_front()
			#owner.window.focus(owner)		#change on resize / move instead
			#print("active window has changed")
		# this was the only window, now we're in a plain area
		else:
			owner.in_window = false
			owner.window = null
			_change_state("idle")
			#print("out in the open!")

	# we exited some window in the window stack, remove it
	else:
		owner.window_stack.erase(window)
			


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)
