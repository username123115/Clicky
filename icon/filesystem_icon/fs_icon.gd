extends Icon
class_name FileIcon

@export var file : FileNode
@export var window_initial_offset : Vector2 = Vector2(100, 100)
@export var window_placement_offset : Vector2 = Vector2(25, 25)

@export var directory_texture : Texture2D
@export var note_texture : Texture2D
@export var exec_texture : Texture2D
@export var default_texture : Texture2D

var root_pos : Vector2
var next_pos : Vector2

var current_index = 0

var free_sections : Array[GameWin]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	root_pos = global_position + window_initial_offset
	next_pos = root_pos
	update_icons()

func update_icons() -> void:
	var t : Texture2D = default_texture
	match file.type:
		Enums.FileType.ROOT:
			t = directory_texture
		Enums.FileType.DIRECTORY:
			t = directory_texture
		Enums.FileType.TEXT:
			t = note_texture
		Enums.FileType.EXEC:
			t = exec_texture
		_:
			t = default_texture
	sprite.texture = t



func click_registered(clicker = null):
	if click_count == 2:
		var scene := file.scene;

		#TODO: Add this to root rather than owner?
		var node := scene.instantiate() as GameWin
		#await node.ready
		node.notify_on_move = true
		node.connect("window_moved", _on_window_moved)
		node.file = file
		node.file_changed()

		#calculate position
		var ind := free_sections.find(null) as int
		var nth_pos : int = 0
		if (ind >= 0):
			free_sections[ind] = node
			nth_pos = ind
		else:
			free_sections.push_back(node)
			nth_pos = len(free_sections)
		node.global_position = global_position + window_initial_offset + window_placement_offset * nth_pos

		get_tree().current_scene.add_child(node)
		#owner.add_child(node)

func _on_window_moved(window):
	window.disconnect("window_moved", _on_window_moved)
	var ind := free_sections.find(window) as int
	if (ind >= 0):
		free_sections[ind] = null
