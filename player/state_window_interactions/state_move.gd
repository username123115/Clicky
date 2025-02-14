extends "rectangle.gd"

var prev_pos : Vector2
func enter() -> void:
	assert(owner.in_window)
	prev_pos = owner.global_position
	owner.window_move = true
	owner.window.focus(owner)

func update(delta: float) -> void:
	if not Input.is_action_pressed("grab"):
		finished.emit("previous")
		return

	var d := owner.global_position - prev_pos as Vector2
	prev_pos = owner.global_position

	owner.window.global_position += d
	

func exit() -> void:
	owner.window_move = false
	
