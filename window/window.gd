extends CharacterBody2D

signal window_size_changed()

@export var init_height: int = 50
@export var init_width: int = 50

var height: int:
	get:
		return height
	set(value):
		height = value
		set_boundary()
		
var width: int:
	get:
		return width
	set(value):
		width = value
		set_boundary()

@onready var area : Area2D =  $Area
@onready var col_shape : CollisionShape2D = $Area/CollisionShape2D


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
	r.position = global_position + size / -2.0
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
	window_size_changed.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:

	var r := Rect2()
	r.size = Vector2(width, height)
	r.position = Vector2(width, height) / -2.0
	
	draw_rect(r, Color.WHITE)
	draw_rect(r, Color.BLACK, false, 1.0)
