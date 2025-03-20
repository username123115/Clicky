extends Sprite2D
@export var lerp_speed: float = 100.0

var base_offset : Vector2
var last_global : Vector2

func _ready() -> void:
	base_offset = position
	last_global = global_position

func _process(delta: float) -> void:
	last_global = last_global.lerp(owner.global_position, delta * lerp_speed)
	global_position = last_global + base_offset
