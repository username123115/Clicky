extends "res://window/window_object.gd"


@onready var container : Area2D = $Container

@export var padding_horizontal : int = 10
@export var padding_vertical : int = 5

var container_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	var collision_shape := container.get_node(^"CollisionShape2D") as CollisionShape2D
	container_size = collision_shape.shape.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var r := Rect2()
	r.size = Vector2(window.width, 30)
	r.position = Vector2(0, 0)
	
	draw_rect(r, Color.GRAY)

func _on_window_size_changed(width, height) -> void:
	queue_redraw()
