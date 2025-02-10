extends CharacterBody2D


@export var height: int = 50:
	get:
		return height
	set(value):
		height = value
		set_boundary()
		
@export var width: int = 50:
	get:
		return width
	set(value):
		width = value
		set_boundary()

@onready var collider : CollisionShape2D =  $Collider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var r = RectangleShape2D.new()
	collider.shape = r
	set_boundary()

	

func set_boundary() -> void:
	queue_redraw()
	if not collider:
		await ready
	collider.shape.size = Vector2(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:

	var r := Rect2()
	r.size = Vector2(width, height)
	r.position = Vector2(-width / 2.0, -height / 2.0)
	
	draw_rect(r, Color.WHITE)
	draw_rect(r, Color.BLACK, false, 1.0)
