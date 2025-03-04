extends Area2D
class_name DeathZone

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_mask = Enums.LayerMasks.PLAYER

func _on_body_entered(body: Node2D):
	EventBus.emit_signal("death_zone_entered", self, body)

