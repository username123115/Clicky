extends ResizeableArea
class_name IconContainer

@onready var area := $Area2D as Area2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D

@export var icon_scale = 0.5
@export var spacing_x : int = 18

var inside : Array[CollisionObject2D] = []
var inner_shape : RectangleShape2D

func _ready():
	super._ready()
	clip_children = ClipChildrenMode.CLIP_CHILDREN_AND_DRAW
	#clip_children = ClipChildrenMode.CLIP_CHILDREN_ONLY

	area.collision_layer = Enums.LayerMasks.CONTAINER;
	area.collision_mask = Enums.LayerMasks.PLAYER | Enums.LayerMasks.CONTAINER

	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
	inner_shape = RectangleShape2D.new()

	col_shape.shape = inner_shape
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
		icon.position = offset + area.position - boundary.size / 2 + Vector2(spacing_x, spacing_x) / 2
		x += spacing_x

func window_size_changed(w, h) -> void:
	super.window_size_changed(w, h)
	area.position = boundary.position
	inner_shape.size = boundary.size

	queue_redraw()

func _draw() -> void:
	var outer := Rect2()

	outer.size = boundary.size
	outer.position = area.position - boundary.size / 2

	
	draw_rect(outer, theme.CCONTAINER_BODY)
	draw_rect(outer, theme.CCONTAINER_OUTLINE, false, -1.0)


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
