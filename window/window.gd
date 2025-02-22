extends CharacterBody2D

signal window_size_changed(width, height)
signal window_hide_changed(hiding)
signal window_focus()
var extensions := []


const WindowExtension = preload("window_extension.gd")

@export var init_height: int = 50
@export var init_width: int = 50

@export var min_height: int = 50
@export var min_width: int = 50

@onready var area : Area2D =  $Area
@onready var col_shape : CollisionShape2D = $Area/CollisionShape2D

var order : int = 0:
	get:
		return order
	set(value):
		order = value
		z_index = WindowOrderer.startIndex + order

@export var hiding : bool = false:
	get:
		return hiding
	set(value):
		hiding = value
		for child in extensions:
			child.window_hide_changed(hiding)
		set_boundary()

var file : FileNode = null:
	get:
		return file
	set(value):
		file = value
		file_changed()

func file_changed() -> void:
	pass
		

var height: int:
	get:
		return height
	set(value):
		if (value < min_height): value = min_height
		height = value
		for child in extensions:
			child.window_size_changed(width, height)
		set_boundary()
		
var width: int:
	get:
		return width
	set(value):
		if (value < min_width): value = min_width
		width = value
		for child in extensions:
			child.window_size_changed(width, height)
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

func extension_add(extension : WindowExtension) -> void:
	self.extensions.push_back(extension)
	extension.window_hide_changed(hiding)
	extension.window_size_changed(width, height)

func extension_remove(extension : WindowExtension) -> void:
	self.extensions.erase(extension)
	if extension in get_children():
		remove_child(extension)


func _ready() -> void:
	var r = RectangleShape2D.new()
	col_shape.shape = r
	height = init_height
	width = init_width
	set_boundary()

	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

	for child in get_children():
		if child is WindowExtension:
			print(child)
			extensions.push_back(child)
	for child in extensions:
		child.window_size_changed(width, height)
		child.window_hide_changed(hiding)
	
	WindowOrderer.add(self)

	area.collision_layer = Enums.LayerMasks.WINDOWS;
	area.collision_mask = Enums.LayerMasks.PLAYER;
			

func window_get_rect() -> Rect2:
	var size := col_shape.shape.size as Vector2

	var r := Rect2()
	#r.position = global_position + size / -2.0
	r.position = global_position
	r.size = size
	return r

func focus(cursor = null):
	WindowOrderer.set_high(self)
	window_focus.emit()

func unfocus(cursor = null):
	pass

# pass the signal up to the event bus
func _on_body_entered(body: Node2D):
	EventBus.emit_signal("window_body_entered", self, body);

func _on_body_exited(body: Node2D):
	EventBus.emit_signal("window_body_exited", self, body);

func set_boundary() -> void:
	if not col_shape:
		await ready
	
	var v: Vector2 = Vector2(width, height)
	if hiding and not col_shape.disabled:
		col_shape.disabled = true
	if not hiding and col_shape.disabled:
		col_shape.disabled = false

	col_shape.shape.size = v#Vector2(w, h)
	# Global position always refers to this window's top left
	area.position = v / 2.0
	window_size_changed.emit(v.x, v.y)

	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	if hiding:
		return

	var r := Rect2()
	r.size = Vector2(width, height)
	r.position = Vector2(0, 0)
	
	draw_rect(r, Color.LIGHT_GRAY)
	draw_rect(r, Color.WHITE, false, -1.0)
