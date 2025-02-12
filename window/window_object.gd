extends Node2D
# A window_object should be a child of a window node, it would be very unwise to do otherwise

var window : Node	#parent

func _ready() -> void:
	# This parent better be a window
	window = get_parent()
	window.connect("window_size_changed", _on_window_size_changed)

func _on_window_size_changed(width, height) -> void:
	pass

