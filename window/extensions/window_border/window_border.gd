extends "res://window/window_extension.gd"
@export var thickness : int = 4

@onready var body := $StaticBody2D as StaticBody2D
@onready var CL := $StaticBody2D/Left as CollisionShape2D;
@onready var CR := $StaticBody2D/Right as CollisionShape2D;
@onready var CU := $StaticBody2D/Up as CollisionShape2D;
@onready var CD := $StaticBody2D/Down as CollisionShape2D;

var RL : RectangleShape2D
var RR : RectangleShape2D
var RU : RectangleShape2D
var RD : RectangleShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	RL = RectangleShape2D.new();
	RR = RectangleShape2D.new();
	RU = RectangleShape2D.new();
	RD = RectangleShape2D.new();

	CL.shape = RL;
	CR.shape = RR;
	CU.shape = RU;
	CD.shape = RD;

	body.collision_layer = Enums.LayerMasks.WINDOWBORDERS;
	body.collision_mask = Enums.LayerMasks.WINDOWBORDERS;

func border_changed(w, h) -> void:
	RL.size = Vector2(thickness, h);
	CL.position = Vector2(0, h / 2);
	RR.size = Vector2(thickness, h);
	CR.position = Vector2(w, h / 2);

	#RU.size = Vector2(w, thickness);
	#CU.position = Vector2(w / 2, 0);
	#RD.size = Vector2(w, thickness);
	#CD.position = Vector2(w / 2 + 1, h);

	var border_width : int = w + thickness
	RU.size = Vector2(border_width, thickness);
	CU.position = Vector2(border_width / 2 - 2, 0);
	RD.size = Vector2(border_width, thickness);
	CD.position = Vector2(border_width / 2 - 2, h);


func window_size_changed(w, h) -> void:
	super.window_size_changed(w, h)
	border_changed(w, h)

func window_hide_changed(hiding) -> void:
	if (hiding):
		body.collision_layer = 0
	else:
		body.collision_layer = Enums.LayerMasks.WINDOWBORDERS;
		body.collision_mask = Enums.LayerMasks.WINDOWBORDERS;

	
