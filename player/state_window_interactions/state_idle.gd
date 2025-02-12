extends 'res://state.gd'

func enter() -> void:
	owner.get_node(^"AnimationPlayer").play("player_idle")
	owner.in_window = false
	owner.window_move = false
