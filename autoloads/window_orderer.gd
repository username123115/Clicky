extends Node

const startIndex : int = -1024
const maxCount : int = 1024

var window_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add(window):

	window.order = len(window_list)
	window_list.push_back(window)

func remove(window):
	if window in window_list:
		var removed_order = window.order
		window_list.erase(window)

		for w in window_list:
			if w.order > removed_order:
				w.order -= 1

func set_high(window):
	remove(window)
	add(window)
