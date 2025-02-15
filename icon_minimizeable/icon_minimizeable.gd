extends "res://icon/icon.gd"

@onready var window = $Window

@export var window_hiding : bool = false

func _ready() -> void:
	super._ready()
	window.hiding = window_hiding

func click_registered(clicker = null):
	window_hiding = not window_hiding
	window.hiding = window_hiding
