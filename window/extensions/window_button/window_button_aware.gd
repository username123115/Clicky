extends GameWin
class_name GameWinBA

@onready var buttons : WindowButtons = $WindowButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons.connect("button_clicked", _on_button_clicked)
	super._ready()


func _on_button_clicked(type : Enums.WindowButtonType) -> void:
	remove_self()

