extends ResizeableArea
class_name DirTitle
@onready var label : Label = $Label

@export var bar_color : Color = Color.BLUE
@export var title : String = "lol":
	get:
		return title
	set(value):
		title = value
		queue_redraw()

func _ready():
	clip_children = ClipChildrenMode.CLIP_CHILDREN_AND_DRAW


func _draw() -> void:
	#print(boundary)
	draw_rect(boundary, bar_color)
	label.text = title
	label.position = boundary.position
