extends Area2D
class_name WindowButtonContainer

@onready var close : Icon = $Close
@onready var minimize : Icon = $Minimize
@onready var cshape := $CollisionShape2D

signal button_clicked(type : Enums.WindowButtonType)

#size after scaling
var actual_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actual_size = scale * cshape.shape.size
	close.connect("clicked", _on_close_clicked)
	minimize.connect("clicked", _on_minimize_clicked)

func _draw() -> void:
	pass

func _on_close_clicked() -> void:
	button_clicked.emit(Enums.WindowButtonType.CLOSE)

func _on_minimize_clicked() -> void:
	button_clicked.emit(Enums.WindowButtonType.MINIMIZE)
