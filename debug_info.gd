extends Node

@onready var l := $Label
@onready var p := owner.get_node(^"Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	l.text = str(p.window_move) + str(p.get_node(^"State Machine Windows").states_stack)
