extends "res://state_machine.gd"

@onready var idle: Node = $Idle
@onready var inside: Node = $Inside

var queued_icons = []

func _ready() -> void:
	states_map = {
		"idle": idle,
		"inside": inside,
	}
	EventBus.connect("icon_body_entered", _on_icon_enter)
	EventBus.connect("icon_body_exited", _on_icon_exit)

func node_is_in(parent, node):
	var children = parent.get_children()
	if len(children) == 0:
		return false
	if node in children:
		return true
	for child in children:
		if node_is_in(child, node):
			return true

func _change_state(state_name: String) -> void:
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["inside"]:
		states_stack.push_front(states_map[state_name])
	if state_name == "idle":
		states_stack = ["idle"]

	super._change_state(state_name)
	#print(states_stack)

func _physics_process(delta : float):
	super._physics_process(delta)

	if len(queued_icons) and not owner.in_window:
		for icon in queued_icons:
			_on_icon_enter(icon, owner)
		queued_icons = []
		


func _on_icon_enter(icon, body):
		
	if body != owner:
		return

	# prevent new icon hovers, exiting old icons is fine however
	if (owner.in_window) and (not node_is_in(owner.window, icon)):
		queued_icons.push_back(icon)
		return
	# handle overlapping icons
	if owner.in_icon:
		owner.icon_stack.push_back(icon)	#if this stack is empty this will become the next active icon
		return

	icon.focus()
	owner.in_icon = true
	owner.icon = icon
	_change_state("inside")


func _on_icon_exit(icon, body):
	if body != owner:
		return

	if icon == owner.icon:
		icon.unfocus()
		# don't set this to false, find the next icon we entered and set that as active
		if len(owner.icon_stack):
			owner.icon = owner.icon_stack.pop_front()
			owner.icon.focus()
		# this was the only icon, now we're in a plain area
		else:
			owner.in_icon = false
			owner.icon = null
			_change_state("idle")

	# we exited some icon in the icon stack, remove it
	else:
		queued_icons.erase(icon)
		owner.icon_stack.erase(icon)

func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)
