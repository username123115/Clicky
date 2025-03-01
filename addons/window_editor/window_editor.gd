@tool
extends EditorPlugin

enum Positions {
	TL,
	TR,
	BL,
	BR
	}

class Anchor:
	var position : Vector2
	var kind : Positions
	var rectangle : Rect2 = Rect2()
	var radius : int = 3


	func calculate_position(r : Rect2):
		var pos := r.position
		var size = r.size
		
		match kind:
			Positions.TL: position = pos + Vector2(0, 0)
			Positions.TR: position = pos + Vector2(size.x, 0)
			Positions.BL: position = pos + Vector2(0, size.y)
			Positions.BR: position = pos + size

		rectangle.size = Vector2(6, 6)
		rectangle.position = position - rectangle.size / 2
		#rectangle.position = position - rectangle.size /  2 - pos
	
	func contains(point : Vector2) -> bool:
		return rectangle.has_point(point)

	func draw(transform : Transform2D, overlay : Control):
		var zoom : float = transform.x.x
		var global_p : Vector2 = transform * position
		var rect_p : Vector2 = transform * (position - rectangle.size / 2)

		overlay.draw_circle(global_p, 3 * zoom, Color.LIGHT_SALMON, true, -1.0, true)
		overlay.draw_circle(global_p, 2 * zoom, Color.WHITE, true, -1.0, true)

		var new_rect : Rect2 = Rect2()
		new_rect.size = rectangle.size * zoom
		new_rect.position = rect_p
		overlay.draw_rect(new_rect, Color.BLACK, false, 2.0)


var editing : GameWin = null
var anchors := {}
var resize_rect : Rect2 = Rect2()
var resizing : bool = false
var resize_anchor : Anchor = null

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	for type in [Positions.TL, Positions.TR, Positions.BL, Positions.BR]:
		var anchor := Anchor.new()
		anchor.radius = 3
		anchor.kind = type
		anchors[type] = anchor

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func _has_main_screen():
	return false

func _make_visible(visible):
	pass

func _get_plugin_name():
	return "GameWin Editor"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")

func _forward_canvas_draw_over_viewport(overlay : Control):
	if not editing:
		return
	for anchor : Anchor in anchors.values():
		if not resizing:
			anchor.calculate_position(window_to_rect(editing, false))
		else:
			anchor.calculate_position(resize_rect)

		#var transform : Transform2D = editing.get_global_transform_with_canvas()
		var transform : Transform2D = editing.get_viewport().get_final_transform() * editing.get_global_transform()
		anchor.draw(transform, overlay)
		#anchor.draw(editing.get_viewport().get_final_transform(), overlay)

func window_to_rect(win : GameWin, do_global_position : bool = true) -> Rect2:
	var r : Rect2 = Rect2()
	if do_global_position:
		r.position = win.position
	else:
		r.position = Vector2(0, 0)
	r.size = Vector2(win.init_width, win.init_height)
	return r

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if not editing:
		return false

	var pos := editing.get_local_mouse_position()

	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if not event.pressed:
				if resizing:
					#finished dragging
					var r : Rect2 = editing.get_transform() * resize_rect

					if r.size.x < 0:
						r.position.x += resize_rect.size.x
						r.size.x *= -1

					if r.size.y < 0:
						r.position.y += resize_rect.size.y
						r.size.y *= -1

					editing.position = r.position
					editing.init_width = r.size.x
					editing.init_height = r.size.y
					resizing = false
					update_overlays()
				return false
			if event.pressed:
				for anchor : Anchor in anchors.values():
					if anchor.contains(pos):
						resizing = true
						resize_anchor = anchor
						resize_rect = window_to_rect(editing)
						return true
			
	if not resizing:
		return false

	var g := editing.get_local_mouse_position()
	var old_pos = resize_rect.position
	var opposite : Vector2

	match resize_anchor.kind:
		Positions.TL:
			opposite = anchors[Positions.BR].position
			resize_rect.size = opposite - g
			resize_rect.position = g
		Positions.TR:
			opposite = anchors[Positions.BL].position
			resize_rect.size = Vector2(g.x - opposite.x, opposite.y - g.y)
			resize_rect.position = g - Vector2(resize_rect.size.x, 0)
		Positions.BL:
			opposite = anchors[Positions.TR].position
			resize_rect.size = Vector2(opposite.x - g.x, g.y - opposite.y)
			resize_rect.position = g - Vector2(0, resize_rect.size.y)
			update_overlays()
		Positions.BR:
			opposite = anchors[Positions.TL].position
			resize_rect.size = g - opposite
			resize_rect.position = g - resize_rect.size

	print(resize_rect.size)

	update_overlays()
	return true

		

	return false

func _edit(object : Object) -> void:
	editing = object

func _handles(object : Object):
	if not Engine.is_editor_hint():
		return false
	return object is GameWin
