extends CharacterBody2D

class_name GameWin

signal window_size_changed(width, height)
signal window_hide_changed(hiding)
signal window_focus()
signal window_moved(window)
var notify_on_move = false;

var extensions := []

@export var init_height: int = 50
@export var init_width: int = 50

@export var min_height: int = 50
@export var min_width: int = 50

@onready var area : Area2D =  $Area
@onready var col_shape : CollisionShape2D = $Area/CollisionShape2D

@export var theme : ColorScheme = preload("res://colors/cs_default.tres")

func move(offset : Vector2):
	global_position += offset
	if notify_on_move and (offset.abs()):
		notify_on_move = false
		window_moved.emit(self)

var order : int = 0:
	get:
		return order
	set(value):
		order = value
		z_index = WindowOrderer.startIndex + order

@export var hiding : bool = false:
	#get:
	#	return hiding
	set(value):
		hiding = value
		for child in extensions:
			child.window_hide_changed(hiding)
		set_boundary()

@export var starting_file : FileNode = null
var file : FileNode = null

func file_changed() -> void:
	return
		

var height: int:
	get:
		return height
	set(value):
		#if value % 2:
		#	value -= 1
		if (value < min_height): value = min_height
		height = value
		for child in extensions:
			child.window_size_changed(width, height)
		set_boundary()
		
var width: int:
	get:
		return width
	set(value):
		if value % 2:
			value -= 1
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
			move(Vector2(value, 0))
			#global_position.x += value
		width -= value

# expand from bottom otherwise expand top
func expand_height(value : int, direction : bool):
	if direction:
		height += value
	else:
		if (height - value >= min_height):
			move(Vector2(0, value))
			#global_position.y += value
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
			#print(child)
			extensions.push_back(child)
	for child in extensions:
		child.window_size_changed(width, height)
		child.window_hide_changed(hiding)
	
	WindowOrderer.add(self)

	area.collision_layer = Enums.LayerMasks.WINDOWS;
	area.collision_mask = Enums.LayerMasks.PLAYER;

	if starting_file:
		file = starting_file
		file_changed()
			

func window_get_rect() -> Rect2:
	var size := col_shape.shape.size as Vector2

	var r := Rect2()
	#r.position = global_position + size / -2.0
	r.position = global_position
	r.size = size
	return r

func remove_self() -> void:
	WindowOrderer.remove(self)
	queue_free()

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
	var r_inner := Rect2()
	var r_outer := Rect2()

	r_inner.size = Vector2(width, height)
	r_inner.position = Vector2(0, 0)

	r_outer.size = Vector2(width + 2, height + 2)
	r_outer.position = Vector2(-1, -1)

	if not hiding:
		
		draw_rect(r_outer, theme.CWINDOW_OUTLINE)#, false, -1.0)
		draw_rect(r_inner, theme.CWINDOW_BODY)
	else:
		draw_rect(r_inner, theme.CWINDOW_HIDING, false, -1.0)
	#draw_rect(r, Color.LIGHT_GRAY)
	#draw_rect(r, Color.WHITE, false, -1.0)
