extends Node

@export var lerp_speed = 5.0
@export var lerp_fast = 15.0

@export var increase_lerp_distance = 10.0
@export var snap_distance = 3.0

var zone : CameraZone
var target : Vector2

var follow_snap : bool = false

func _ready() -> void:
	if owner.CAMERA:
		print("connected")
		EventBus.connect("camera_zone_entered", change_zone)

func change_zone(z : CameraZone, b : Node2D):
	print("yes")
	if not b == owner:
		pass
	zone = z
	target = zone.focal_point.global_position
	follow_snap = false

func _physics_process(delta: float) -> void:
	if not zone:
		return

	var cam := owner.CAMERA as Camera2D
	var cam_pos : Vector2

	match zone.behavior:
		Enums.CameraBehavior.CENTER:
			if cam.global_position.is_equal_approx(target):
				cam_pos = target
			else:
				cam_pos = cam.global_position.lerp(target, delta * lerp_speed)
		Enums.CameraBehavior.FOLLOW:
			target = owner.global_position
			var fp : Vector2 = zone.focal_point.global_position
			var lx = Vector2(fp.x, fp.x) + zone.limit_x
			var ly = Vector2(fp.y, fp.y) + zone.limit_y
			target.x = limit_value(target.x, lx)
			target.y = limit_value(target.y, ly)

			if follow_snap:
				cam_pos = target
			else:
				cam_pos = cam.global_position.lerp(target, delta * lerp_fast)
				if cam_pos.distance_to(target) < snap_distance:
					cam_pos = target
					follow_snap = true

	cam.global_position = cam_pos.round()

func limit_value(v : float, limits : Vector2):
	if v < limits.x:
		return limits.x
	if v > limits.y:
		return limits.y
	return v
	
	
