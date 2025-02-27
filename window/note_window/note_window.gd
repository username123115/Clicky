extends GameWinBA

@onready var title : DirTitle = $Title
@onready var text : TextContainer = $Text

func file_changed() -> void:
	await ready
	title.title = "TX." + file.name
	text.text = file.data
	queue_redraw()
