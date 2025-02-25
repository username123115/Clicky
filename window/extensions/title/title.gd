extends ResizeableArea
@onready var label : Label = $Label

@export var title : String = "lol"


func _draw() -> void:
	print(boundary)
	draw_rect(boundary, Color.BLUE)
	label.text = title
	label.position = boundary.position
