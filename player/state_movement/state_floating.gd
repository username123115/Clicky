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

	var old := owner.global_position as Vector2

	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta)
	owner_velocity.y = step_towards(owner_velocity.y, target_velocity.y, _delta)
	owner.velocity = owner_velocity

	owner.move_and_slide()

	var d := owner.global_position - old as Vector2
	if owner.window_edge and owner.window_grab:
		var up : bool = owner.window_grab_state['u']
		var down : bool = owner.window_grab_state['d']
		var left : bool = owner.window_grab_state['l']
		var right : bool = owner.window_grab_state['r']

		var h : bool = left or right
		var v : bool = up or down

		var rectangle = owner.window.window_get_rect() as Rect2

		if h:
			# calculate the left offset
			var distance : float = owner.global_position.x - rectangle.position.x
			if right:
				distance -= rectangle.size.x
			owner.window.expand_width(distance, right)

		if v:
			# calculate the top offset
			var distance : float = owner.global_position.y - rectangle.position.y
			if down:
				distance -= rectangle.size.y
			owner.window.expand_height(distance, down)


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
