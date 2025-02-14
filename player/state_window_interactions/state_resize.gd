extends 'rectangle.gd'

var old_animation: String
signal debug_draw(rect_a, rect_b)

func enter() -> void:
	print("RESIZE!")
	var animation_player := owner.get_node(^"AnimationPlayer")
	old_animation = animation_player.current_animation
	if not old_animation:
		old_animation = "player_idle"
	animation_player.play("player_resize")

	owner.window_edge = true
	owner.window_move = false



func update(_delta: float):
	assert(owner.in_window)
	var window_rect := owner.window.window_get_rect() as Rect2
	var own_rect := player_get_rect()

	debug_draw.emit(window_rect, own_rect)

	if window_rect.encloses(own_rect):
		finished.emit('previous')
		return

	# Otherwise detect which of the four sides are being touched
	if Input.is_action_pressed("grab"):
		owner.window.focus(owner)

		var left: bool = own_rect.position.x < window_rect.position.x
		var right: bool = own_rect.position.x + own_rect.size.x > window_rect.position.x + window_rect.size.x

		var up: bool = own_rect.position.y < window_rect.position.y
		var down: bool = own_rect.position.y + own_rect.size.y > window_rect.position.y + window_rect.size.y

		owner.window_grab = true

		owner.window_grab_state['l'] = left
		owner.window_grab_state['r'] = right
		owner.window_grab_state['u'] = up
		owner.window_grab_state['d'] = down
	else:
		owner.window_grab = false
		

func exit() -> void:
	var animation_player := owner.get_node(^"AnimationPlayer")
	animation_player.play(old_animation)
	owner.window_edge = false
	owner.window_grab = false
	
