extends ResizeableArea
class_name DirTitle
@onready var label : Label = $Label

@export var title : String = "lol":
	get:
		return title
	set(value):
		title = value
		queue_redraw()


func _draw() -> void:
	#print(boundary)
	draw_rect(boundary, Color.BLUE)
	label.text = title
	label.position = boundary.position
