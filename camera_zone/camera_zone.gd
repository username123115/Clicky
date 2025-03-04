extends Area2D
class_name CameraZone

@export var behavior : Enums.CameraBehavior = Enums.CameraBehavior.CENTER
@export var focal_point : Node2D

@export var limit_x : Vector2 = Vector2(-10000, 10000)
@export var limit_y : Vector2 = Vector2(-10000, 10000)

func _ready() -> void:
	if not focal_point:
		focal_point = get_node(^"DefaultFocal")
	body_entered.connect(_on_body_entered)
	collision_mask = Enums.LayerMasks.PLAYER

func _on_body_entered(body: Node2D):
	print("enter!")
	EventBus.emit_signal("camera_zone_entered", self, body)
