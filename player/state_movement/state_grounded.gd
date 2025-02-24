extends "moveable.gd"

@onready var float_speed = owner.WALK_SPEED
@onready var accel = owner.WALK_ACCELL

@export var coyote_frames : int = 6;
var remaining_frames = coyote_frames;

func enter() -> void:
	remaining_frames = coyote_frames

func update(_delta: float) -> void:

	var direction := get_input_direction()
	var owner_velocity = owner.velocity

	var target_velocity = float_speed * direction

	owner_velocity.x = step_towards(owner_velocity.x, target_velocity.x, _delta, accel)
	owner_velocity.y += owner.GRAVITY * _delta;

	owner.velocity = owner_velocity

	owner.move_and_slide()

	if owner.is_on_floor():		#reset coyote frames
		remaining_frames = coyote_frames
	else:
		remaining_frames -= 1
		if remaining_frames <= 0:
			#print("bye")
			finished.emit("falling")
	
	if Input.is_action_just_pressed("jump"):
		if owner.velocity.y > 0:
			owner.velocity.y = 0
		owner.velocity.y -= owner.JUMP;
		#print("bye")
		finished.emit("falling");

