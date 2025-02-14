extends "res://icon/icon.gd"

@onready var col_shape := $Area2D/CollisionShape2D

var contact_count : int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw() -> void:
	var r := Rect2()
	r.size = col_shape.shape.size
	r.position = Vector2(0, 0)

	if contact_count:
		draw_rect(r, Color.LIGHT_PINK)
	else:
		draw_rect(r, Color.LIGHT_GRAY)
	draw_rect(r, Color.WHITE, false, -1.0)

