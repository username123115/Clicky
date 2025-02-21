extends 'res://state.gd'

func _ready() -> void:
	pass

# move towards but if moving faster in the same direction deceleration doesn't happen
func step_towards(value : float, target : float, delta : float, accel : float):
	if (target < 0):
		if (value > target):
			value -= accel * delta
			return max(target, value)
	elif (target == 0):
		if (value > 0):
			value -= min(value, delta * accel)
		else:
			value += min(abs(value), delta * accel)
	else:
		if (value < target):
			value += accel * delta
			return min(target, value)

	return value
			



func get_input_direction() -> Vector2:
	return Vector2(
			Input.get_axis(&"move_left", &"move_right"),
			Input.get_axis(&"move_up", &"move_down")
	)
