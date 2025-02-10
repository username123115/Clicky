extends 'res://state.gd'

func enter() -> void:
	owner.get_node(^"AnimationPlayer").play("player_idle")
