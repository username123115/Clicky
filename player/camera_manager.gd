extends Node

@export var lerp_speed = 10.0

var zone : CameraZone
var target : Vector2

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

func _physics_process(delta: float) -> void:
	if not zone:
		return
	match zone.behavior:
		Enums.CameraBehavior.CENTER:
			pass
		Enums.CameraBehavior.FOLLOW:
			target = owner.global_position
	var cam := owner.CAMERA as Camera2D
	if cam.global_position.is_equal_approx(target):
		return
	cam.global_position = cam.global_position.lerp(target, delta * lerp_speed)
	
	
