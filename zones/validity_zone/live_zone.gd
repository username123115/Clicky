extends Area2D
class_name LiveZone

@onready var SpawnPoint : Node2D = $SpawnPoint

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_mask = Enums.LayerMasks.PLAYER

func _on_body_entered(body: Node2D):
	EventBus.emit_signal("live_zone_entered", self, body)

func _on_body_exited(body: Node2D):
	EventBus.emit_signal("live_zone_exited", self, body)
