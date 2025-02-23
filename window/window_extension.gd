extends Node2D
class_name WindowExtension
# A window_object should be a child of a window node, it would be very unwise to do otherwise

var window : Node	#parent
var is_hiding : bool = false

var width : int
var height : int

func _ready() -> void:
	pass
	# This parent better be a window

func window_size_changed(w : int, h : int) -> void:
	width = w
	height = h

func window_hide_changed(hiding) -> void:
	is_hiding = hiding


