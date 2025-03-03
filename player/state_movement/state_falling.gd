extends "moveable.gd"

@onready var float_speed = owner.WALK_SPEED
@onready var accel = owner.WALK_ACCELL

var can_reduce_gravity : bool

func enter() -> void:
	can_reduce_gravity = true

func update(_delta: float) -> void:
	if can_reduce_gravity:
		if not Input.is_action_pressed("jump"):
			can_reduce_gravity = false
		if owner.velocity.y > 0:
			can_reduce_gravity = false

	var gravity : float
	if can_reduce_gravity:
		gravity = owner.GRAVITY_WEAK
	else:
		gravity = owner.GRAVITY

	apply_gravity(_delta, gravity)
	handle_jump()

func apply_gravity(_delta : float, gravity : float) -> void:
	var direction := get_input_direction()
	var owner_velocity = owner.velocity
	var target_velocity = float_speed * direction
	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta, accel)
	owner_velocity.y += gravity * _delta;
	owner.velocity = owner_velocity

	owner.move_and_slide()
	if owner.is_on_floor():
		finished.emit("grounded");



func handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		# test for walls
		var orig_p := Vector2(owner.global_position)
		var orig_v := Vector2(owner.velocity)
		var new := Vector2(orig_v)

		var jumping : bool = false
		var moving : bool = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		var bias = owner.WALL_JUMP_STRONG if moving else owner.WALL_JUMP_WEAK

		var move_velocity := 1
		# test right
		var right = owner.move_and_collide(Vector2(move_velocity, 0), true)
		if right:
			new.y = -owner.JUMP;
			if new.x > -bias:
				new.x = max(new.x - bias, -bias);
			jumping = true

		var left = owner.move_and_collide(Vector2(-move_velocity, 0), true)
		if left:
			new.y = -owner.JUMP;
			if new.x < bias:
				new.x = min(new.x + bias, bias);
			jumping = true

		owner.global_position = orig_p
		owner.velocity = new;
		if jumping:
			emit_jump()


func emit_jump() -> void:
	can_reduce_gravity = true
