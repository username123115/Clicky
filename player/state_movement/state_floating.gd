extends 'res://state.gd'
@onready var float_speed = owner.FLOAT_SPEED
@onready var accel = owner.FLOAT_ACCELL


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update(_delta: float) -> void:
	var direction := get_input_direction()
	var owner_velocity = owner.velocity

	var target_velocity = float_speed * direction

	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta)
	owner_velocity.y = step_towards(owner_velocity.y, target_velocity.y, _delta)

	owner.velocity = owner_velocity

	owner.move_and_slide()


# move towards but if moving faster in the same direction deceleration doesn't happen
func step_towards(value : float, target : float, delta : float):
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
