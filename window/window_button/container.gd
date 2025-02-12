extends Area2D

@onready var close := $Close
@onready var minimize := $Minimize
@onready var cshape := $CollisionShape2D

#size after scaling
var actual_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actual_size = scale * cshape.shape.size

func _draw() -> void:
	pass
