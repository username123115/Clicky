extends Icon

@onready var window : GameWin = $Window

@export var window_hiding : bool = false
@export var closed : bool = false

func _ready() -> void:
	super._ready()

	var container = window.get_node(^"WindowButton/Container")
	var close = container.get_node(^"Close")
	var minimize = container.get_node(^"Minimize")

	if closed:
		window.hiding = true
	else:
		window.hiding = window_hiding

	minimize.connect("clicked", _on_minimize_clicked)
	close.connect("clicked", _on_close_clicked)

	appearance_default()

func _on_minimize_clicked():
	window.hiding = true

func appearance_default() -> void:
	if closed:
		sprite.self_modulate = Color(0.8, 0.8, 0.8, 1.0)
	else:
		sprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_close_clicked():
	window.hiding = true
	closed = true

func click_registered(clicker = null):
	if click_count > 1:
		closed = false
	if not closed:
		window.hiding = not window.hiding
