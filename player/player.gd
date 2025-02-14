extends CharacterBody2D

@export var FLOAT_SPEED : float = 450.0
@export var FLOAT_ACCELL : float = 900.0

enum GrabState { GRAB_LEFT, GRAB_NONE, GRAB_RIGHT }

var in_icon : bool = false
var icon : Node
var icon_stack := []

var in_window : bool = false	#for the window FSM, tracks whether or not player is in a window
var window : Node				#if `in_window` is set, this is the window the player is in
var window_stack := []

var window_edge : bool = false	#set when player is at the edge of a window
var window_grab : bool = false	#set when player is grabbing a window

var window_move : bool = false

var window_grab_state = {
	"l": false,
	"r": false,
	"u": false,
	"d": false,
	}
