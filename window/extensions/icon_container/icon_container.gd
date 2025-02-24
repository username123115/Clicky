extends WindowExtension
class_name IconContainer

@onready var area := $Area2D as Area2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

@export var pin_right : bool = true
@export var pin_top : bool = true
@export var y_diff : int = 20
@export var other_y_diff : int = 5

@export var x_diff : int = 5
@export var other_x_diff : int = 5

@export var x_scale : float = 1.0
@export var y_scale : float = 1.0

@export var icon_scale = 0.5
@export var spacing_x : int = 18

var r : RectangleShape2D
var inside : Array[CollisionObject2D] = []

func _ready():
	super._ready()
	r = RectangleShape2D.new()

	clip_children = ClipChildrenMode.CLIP_CHILDREN_AND_DRAW
	#clip_children = ClipChildrenMode.CLIP_CHILDREN_ONLY

	area.collision_layer = Enums.LayerMasks.CONTAINER;
	area.collision_mask = Enums.LayerMasks.PLAYER | Enums.LayerMasks.CONTAINER

	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

	col_shape.shape = r
	update_icons()


func clear_icons() -> void:
	for child in get_children():
		if child is Icon:
			remove_child(child)
			child.queue_free()

func update_icons() -> void:
	var icon_list : Array[Icon] = []
	icon_list = []
	for child in get_children():
		if child is Icon:
			icon_list.push_back(child)
			child.set_col_mask(Enums.LayerMasks.CONTAINER);
	var x : int = 0
	for icon in icon_list:
		var offset = Vector2(x, 0)
		icon.position = offset + area.position - r.size / 2 + Vector2(spacing_x, spacing_x) / 2
		x += spacing_x

func window_size_changed(w, h) -> void:
	super.window_size_changed(w, h)
	var new_size := Vector2(x_scale * (w - (x_diff + other_x_diff)), y_scale * (h - (y_diff + other_y_diff)))
	r.size = new_size

	if pin_top:
		area.position.y = (new_size.y / 2) + y_diff
	else:
		area.position.y = (h - new_size.y / 2) - y_diff

	if pin_right:
		area.position.x = (w - new_size.x / 2) - x_diff
	else:
		area.position.x = new_size.x / 2 + x_diff

	queue_redraw()

func _draw() -> void:
	var rec := Rect2()
	rec.size = r.size
	rec.position = area.position - r.size / 2
	
	draw_rect(rec, Color.GRAY)
	draw_rect(rec, Color.BLACK, false, -1.0)


func _physics_process(delta: float) -> void:
	for body in inside:
		body.set_collision_layer_value(Enums.LayerValues.CONTAINER, true)
	

func window_hide_changed(hiding) -> void:
	super.window_hide_changed(hiding)

func _on_body_entered(body):
	if body is CollisionObject2D:
		body.set_collision_layer_value(Enums.LayerValues.CONTAINER, true)
		inside.push_back(body)


func _on_body_exited(body):
	if body is CollisionObject2D:
		body.set_collision_layer_value(Enums.LayerValues.CONTAINER, false)
		inside.erase(body)
