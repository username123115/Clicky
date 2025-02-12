extends Node2D


@onready var area : Area2D =  $Area2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var r := Rect2()
	var size := col_shape.shape.size as Vector2
	r.position = size / -2.0
	r.size = size

	draw_rect(r, Color.WHITE)
	draw_rect(r, Color.BLACK, false, 1.0)
