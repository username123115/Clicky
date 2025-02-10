extends CanvasItem

@export var target: Node
var resize : Node

var a: Rect2
var b: Rect2

func _ready() -> void:
	resize = target.get_node(^"State Machine Windows/Resize")
	resize.connect("debug_draw", _on_debug_draw)

func _on_debug_draw(window : Rect2, box : Rect2):
	a = window
	b = box
	queue_redraw()
	
	

func _draw() -> void:

	#draw_rect(r, Color.WHITE)
	draw_rect(a, Color.BLACK, false, 1.0)
	draw_rect(b, Color.BLACK, false, 1.0)
