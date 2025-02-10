extends CharacterBody2D

@export var FLOAT_SPEED : float = 450.0
@export var FLOAT_ACCELL : float = 900.0

var in_window : bool = false	#for the window FSM, tracks whether or not player is in a window
var window : Node				#if `in_window` is set, this is the window the player is in
var window_stack := []

var resizing_window : bool = false
