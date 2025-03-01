extends "moveable.gd"
@onready var float_speed = owner.WALK_SPEED
@onready var accel = owner.WALK_ACCELL

func update(_delta: float) -> void:

	var direction := get_input_direction()
	var owner_velocity = owner.velocity

	var target_velocity = float_speed * direction

	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta, accel)
	owner_velocity.y += owner.GRAVITY * _delta;

	owner.velocity = owner_velocity

	owner.move_and_slide()
	if owner.is_on_floor():
		finished.emit("grounded");

	if Input.is_action_just_pressed("jump"):
		# test for walls
		var orig_p := owner.global_position as Vector2
		var orig_v := owner.velocity as Vector2
		var new := orig_v

		# test left
		var moving : bool = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		var bias = owner.WALL_JUMP_STRONG if moving else owner.WALL_JUMP_WEAK
		owner.velocity = Vector2(-3 / _delta, 0)

		owner.move_and_slide()
		if owner.is_on_wall():
			new.y = -owner.JUMP;
			if new.x < bias:
				new.x = min(new.x + bias, bias);
		# test right
		owner.position = orig_p
		owner.velocity = Vector2(3 / _delta, 0)
		owner.move_and_slide()
		if owner.is_on_wall():
			new.y = -owner.JUMP;
			if new.x > -bias:
				new.x = max(new.x - bias, -bias);

		owner.global_position = orig_p
		owner.velocity = new;

