extends Node

var zone : CameraZone

func _ready() -> void:
	if owner.CAMERA:
		print("connected")
		EventBus.connect("camera_zone_entered", change_zone)

func change_zone(z : CameraZone, b : Node2D):
	print("yes")
	if not b == owner:
		pass
	zone = z
	owner.CAMERA.global_position = zone.focal_point.global_position
