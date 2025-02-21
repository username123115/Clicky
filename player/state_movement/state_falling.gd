extends "moveable.gd"
@onready var float_speed = owner.WALK_SPEED
@onready var accel = owner.WALK_ACCELL

func update(_delta: float) -> void:

	var direction := get_input_direction()
	var owner_velocity = owner.velocity

	var target_velocity = float_speed * direction

	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta, accel)
	owner_velocity.y += owner.GRAVITY;

	owner.velocity = owner_velocity

	owner.move_and_slide()
