extends "res://icon/icon.gd"

@onready var col_shape := $Area2D/CollisionShape2D

var draw_focus : bool = false
var draw_click : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw() -> void:
	var r := Rect2()
	r.size = col_shape.shape.size
	r.position = Vector2(0, 0)

	if draw_focus:
		draw_rect(r, Color.LIGHT_PINK)
	else:
		draw_rect(r, Color.LIGHT_GRAY)
	if draw_click:
		draw_rect(r, Color.WHITE)
	draw_rect(r, Color.WHITE, false, -1.0)

func appearance_default() -> void:
	draw_focus = false
	draw_click = false
	queue_redraw()

func appearance_hover() -> void:
	draw_focus = true
	draw_click = false
	queue_redraw()

func appearance_clicked() -> void:
	draw_focus = false
	draw_click = true
	queue_redraw()
