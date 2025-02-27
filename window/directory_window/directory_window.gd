extends GameWin
@export var icon_scene : PackedScene

@onready var container : IconContainer = $"IconContainer"
@onready var title : DirTitle = $Title

func _ready() -> void:
	super._ready()

func file_changed() -> void:
	await ready
	var files := file.get_children()
	container.clear_icons()

	title.bar_color = theme.CWINDOW_TITLE_BODY
	
	for f in files:
		if not f is FileNode:
			continue
		var icon := icon_scene.instantiate() as FileIcon
		#await icon.ready
		icon.file = f
		container.add_child(icon)
	container.update_icons()
	title.title = file.name
