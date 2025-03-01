extends GameWinBA

@export var text_override : String = ""
@export var title_override : String = ""

@onready var title : DirTitle = $Title
@onready var text : TextContainer = $Text

func file_changed() -> void:
	await ready
	if title_override == "":
		title.title = "" + file.name
	else:
		title.title = title_override
	if text_override == "":
		text.text = file.data
	else:
		text.text = text_override
	queue_redraw()
