extends "res://window/window_extension.gd"
const WindowExtension = preload("window_extension.gd")

var extensions = []

func _ready() -> void:
	super._ready()
	for child in get_children():
		if child is WindowExtension:
			print(child)
			extensions.push_back(child)

func window_size_changed(w, h) -> void:
	width = w
	height = h

func window_hide_changed(hiding) -> void:
	is_hiding = hiding
