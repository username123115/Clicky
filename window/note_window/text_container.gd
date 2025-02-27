extends ResizeableArea
class_name TextContainer

@onready var label : Label = $Label

@export var text : String = "12345!":
	set(value):
		label.text = text
	get:
		return text

func window_size_changed(w, h):
	super.window_size_changed(w, h)
	label.position = boundary.position
