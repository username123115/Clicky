extends AnimatedSprite2D

@export var speed : float = 25.0
@export var patrol_range : float = 100.0
@export var off : float = 0
var base : float

var move_right : bool = false

func _ready() -> void:
	base = position.x
	play("default")

func _physics_process(delta : float):
	if move_right:
		off += delta * speed
		if off > patrol_range:
			off = patrol_range
			move_right = false
			scale.x = -1
	else:
		off -= delta * speed
		if off < 0:
			off = 0
			move_right = true
			scale.x = 1
	position.x = base + off
	
