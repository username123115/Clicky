extends Area2D
class_name CameraZone

@export var behavior : Enums.CameraBehavior = Enums.CameraBehavior.CENTER
@export var focal_point : Node2D

func _ready() -> void:
	if not focal_point:
		focal_point = get_node(^"DefaultFocal")
	
func _on_body_entered(body: Node2D):
	print("enter!")
	EventBus.emit_signal("camera_zone_entered", self, body)
