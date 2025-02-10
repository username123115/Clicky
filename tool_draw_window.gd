@tool
extends CanvasItem

var w : int = 0
var h : int = 0

func _process(delta: float):
	if Engine.is_editor_hint():
		if ((owner.init_width != w) or (owner.init_height != h)):
			queue_redraw()
			w = owner.init_width
			h = owner.init_height

func _draw() -> void:

	var r := Rect2()
	r.size = Vector2(w, h)
	r.position = Vector2(-w / 2.0, -h / 2.0)
	
	#draw_rect(r, Color.WHITE)
	draw_rect(r, Color.BLACK, false, 1.0)
