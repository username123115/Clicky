extends Sprite2D
#@export var lerp_speed: float = 100.0

var base_offset : Vector2
#var last_global : Vector2

func _ready() -> void:
	base_offset = position

func _process(delta: float) -> void:
	global_position = owner.global_position.round()
