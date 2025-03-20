extends Node
class_name CameraManager

@export var lerp_speed = 13.0
@export var lerp_fast = 25.0

@export var increase_lerp_distance = 0.0
@export var snap_distance = 10.0

var zone : CameraZone = null
var follow_snap : bool = false

var zone_queue : Array[CameraZone]
var hold_zone : bool = true

func _ready() -> void:
	if owner.CAMERA:
		EventBus.connect("camera_zone_entered", enter_zone)
		EventBus.connect("camera_zone_exited", exit_zone)

func enter_zone(z : CameraZone, b : Node2D):
	if not b == owner:
		pass
	if zone and hold_zone:
		zone_queue.push_front(zone)
	zone = z
	follow_snap = false
	hold_zone = true

func exit_zone(z : CameraZone, b : Node2D):
	if not b == owner:
		pass
	if z == zone:
		if len(zone_queue):
			zone = zone_queue.pop_front()
		else:	#don't queue this zone because we aren't even in it anymore
			hold_zone = false
			return
	else:
		zone_queue.erase(z)
	hold_zone = true

func _physics_process(delta: float) -> void:
	if not zone:
		return

	var cam := owner.CAMERA as Camera2D
	var cam_pos : Vector2

	match zone.behavior:
		Enums.CameraBehavior.CENTER:
			var target := zone.focal_point.global_position
			if cam.global_position.is_equal_approx(target):
				cam_pos = target
			else:
				cam_pos = cam.global_position.lerp(target, delta * lerp_speed)
		Enums.CameraBehavior.FOLLOW:
			#var target : Vector2 = owner.global_position
			var target : Vector2 = owner.global_position.round()
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

	cam.global_position = cam_pos
	#cam.global_position = cam_pos.round()

func limit_value(v : float, limits : Vector2):
	if v < limits.x:
		return limits.x
	if v > limits.y:
		return limits.y
	return v
	
	
