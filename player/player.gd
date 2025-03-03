extends CharacterBody2D
class_name Player

@export var FLOAT_SPEED : float = 450.0
@export var FLOAT_ACCELL : float = 900.0

@export var WALK_SPEED : float = 200.0
@export var WALK_ACCELL : float = 900.0


@export var GRAVITY : float = 980.0
@export var GRAVITY_WEAK : float = 490.0

@export var JUMP : float = 150.0
@export var WALL_JUMP_WEAK : float = 200.0
@export var WALL_JUMP_STRONG : float = 250.0

@export var JUMP_BUFFER_FRAMES : int = 7

enum GrabState { GRAB_LEFT, GRAB_NONE, GRAB_RIGHT }

var jump_buffer : int = 0

var in_icon : bool = false
var icon : Node
var icon_stack := []

var in_window : bool = false	#for the window FSM, tracks whether or not player is in a window
var window : GameWin				#if `in_window` is set, this is the window the player is in
var window_stack : Array[GameWin] = []

var window_edge : bool = false	#set when player is at the edge of a window
var window_grab : bool = false	#set when player is grabbing a window

var window_move : bool = false

var window_grab_state = {
	"l": false,
	"r": false,
	"u": false,
	"d": false,
	}

func _ready() -> void:
	collision_layer = Enums.LayerMasks.PLAYER;
	collision_mask = Enums.LayerMasks.PLAYER;

func enable_border_collisions(v : bool) -> void:
	set_collision_mask_value(Enums.LayerValues.WINDOWBORDERS, v);

func _physics_process(_delta : float):
	jump_buffer -= 1
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_FRAMES

	if (jump_buffer < 0):
		jump_buffer = 0
