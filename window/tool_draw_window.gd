@tool
extends CanvasItem

@onready var rectangle : ColorRect = $ColorRect

var w : int = 0
var h : int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		rectangle.connect("resized", _on_rect_resized)
		rectangle.connect("focus_entered", _on_rect_focus)
	else:
		queue_free()

func _process(delta: float):
	if Engine.is_editor_hint():
		if ((owner.init_width != w) or (owner.init_height != h)):
			queue_redraw()
			w = owner.init_width
			h = owner.init_height
			rectangle.size = Vector2(w, h)

func _draw() -> void:

	var r := Rect2()
	r.size = Vector2(w, h)
	r.position = Vector2(0, 0)
	#r.position = Vector2(-w / 2.0, -h / 2.0)
	
	#draw_rect(r, Color.WHITE)
	draw_rect(r, Color.BLACK, false, 1.0)

func _on_rect_focus() -> void:
	print("so real")

func _on_rect_resized() -> void:
	if rectangle.size != Vector2(owner.init_width, owner.init_height):
		owner.init_width = rectangle.size.x
		owner.init_height = rectangle.size.y
