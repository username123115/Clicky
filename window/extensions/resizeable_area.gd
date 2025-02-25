extends WindowExtension
class_name ResizeableArea

@export var pin_right : bool = true
@export var pin_top : bool = true
@export var y_diff : int = 20
@export var other_y_diff : int = 5

@export var x_diff : int = 5
@export var other_x_diff : int = 5

@export var x_scale : float = 1.0
@export var y_scale : float = 1.0

var boundary : Rect2 = Rect2()

func window_size_changed(w, h) -> void:
	super.window_size_changed(w, h)
	var new_size := Vector2(x_scale * (w - (x_diff + other_x_diff)), y_scale * (h - (y_diff + other_y_diff)))
	boundary.size = new_size

	if pin_top:
		boundary.position.y = (new_size.y / 2) + y_diff
	else:
		boundary.position.y = (h - new_size.y / 2) - y_diff

	if pin_right:
		boundary.position.x = (w - new_size.x / 2) - x_diff
	else:
		boundary.position.x = new_size.x / 2 + x_diff

	queue_redraw()

