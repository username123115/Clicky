extends CharacterBody2D

signal window_size_changed(width, height)

@export var init_height: int = 50
@export var init_width: int = 50

@export var min_height: int = 50
@export var min_width: int = 50

@onready var area : Area2D =  $Area
@onready var col_shape : CollisionShape2D = $Area/CollisionShape2D

var height: int:
	get:
		return height
	set(value):
		if (value < min_height): value = min_height
		height = value
		set_boundary()
		
var width: int:
	get:
		return width
	set(value):
		if (value < min_width): value = min_width
		width = value
		set_boundary()

# expand from right otherwise expand left
func expand_width(value : int, direction : bool):
	if direction:
		width += value
	else:
		if (width - value >= min_width):
			global_position.x += value
		width -= value

# expand from bottom otherwise expand top
func expand_height(value : int, direction : bool):
	if direction:
		height += value
	else:
		if (height - value >= min_height):
			global_position.y += value
		height -= value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var r = RectangleShape2D.new()
	col_shape.shape = r
	height = init_height
	width = init_width
	set_boundary()

	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

func window_get_rect() -> Rect2:
	var size := col_shape.shape.size as Vector2

	var r := Rect2()
	#r.position = global_position + size / -2.0
	r.position = global_position
	r.size = size
	return r

# pass the signal up to the event bus
func _on_body_entered(body: Node2D):
	EventBus.emit_signal("window_body_entered", self, body);

func _on_body_exited(body: Node2D):
	EventBus.emit_signal("window_body_exited", self, body);

func set_boundary() -> void:
	queue_redraw()
	if not col_shape:
		await ready
	col_shape.shape.size = Vector2(width, height)

	# Global position always refers to this window's top left
	area.position = Vector2(width, height) / 2.0
	window_size_changed.emit(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:

	var r := Rect2()
	r.size = Vector2(width, height)
	r.position = Vector2(0, 0)
	
	draw_rect(r, Color.LIGHT_GRAY)
	draw_rect(r, Color.WHITE, false, -1.0)
