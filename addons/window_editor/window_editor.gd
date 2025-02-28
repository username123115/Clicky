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

	func calculate_position(win : GameWin):
		var pos := win.position
		var size = Vector2(win.init_width, win.init_height)
		
		match kind:
			Positions.TL: position = pos
			Positions.TR: position = pos + Vector2(size.x, 0)
			Positions.BL: position = pos + Vector2(0, size.y)
			Positions.BR: position = pos + size

	func draw(win : GameWin, overlay : Control):
		calculate_position(win)
		var zoom : float = win.get_viewport().get_final_transform().x.x
		var global_p : Vector2 = win.get_viewport_transform() * win.get_canvas_transform() * position
		overlay.draw_circle(global_p, 3 * zoom, Color.LIGHT_SALMON, true, -1.0, true)
		overlay.draw_circle(global_p, 2 * zoom, Color.WHITE, true, -1.0, true)


var editing : GameWin = null

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

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

func _forward_canvas_draw_over_viewport(overlay):
	if not editing:
		return
	var zoom : float = editing.get_viewport().get_final_transform().x.x
	var size := Vector2(editing.init_width, editing.init_height)
	var pos := editing.position
	var positions := {
		Positions.TL: pos,
		Positions.TR: pos + Vector2(size.x, 0),
		Positions.BL: pos + Vector2(0, size.y),
		Positions.BR: pos + size
		}

	for anchor in positions.values():
		var global_p : Vector2 = editing.get_viewport_transform() * editing.get_canvas_transform() * anchor
		overlay.draw_circle(global_p, 3 * zoom, Color.LIGHT_SALMON, true, -1.0, true)
		overlay.draw_circle(global_p, 2 * zoom, Color.WHITE, true, -1.0, true)

func _edit(object : Object) -> void:
	editing = object

func _handles(object : Object):
	return object is GameWin
