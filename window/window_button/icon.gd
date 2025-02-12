extends Area2D

@onready var col_shape := $CollisionShape2D

var contact_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw() -> void:
	var r := Rect2()
	r.size = col_shape.shape.size
	r.position = Vector2(0, 0)

	if contact_count:
		draw_rect(r, Color.LIGHT_PINK)
	else:
		draw_rect(r, Color.LIGHT_GRAY)
	draw_rect(r, Color.WHITE, false, -1.0)

func _on_body_entered(body):
	contact_count += 1
	queue_redraw()

func _on_body_exited(body):
	contact_count -= 1
	if (contact_count < 0):
		contact_count = 0
	queue_redraw()
