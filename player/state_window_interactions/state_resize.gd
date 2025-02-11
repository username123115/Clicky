extends 'rectangle.gd'

var old_animation: String
signal debug_draw(rect_a, rect_b)

func enter() -> void:
	var animation_player := owner.get_node(^"AnimationPlayer")
	old_animation = animation_player.current_animation
	if not old_animation:
		old_animation = "player_idle"
	animation_player.play("player_resize")
	owner.resizing_window = true



func update(_delta: float):
	assert(owner.in_window)
	var window_rect := owner.window.window_get_rect() as Rect2
	var own_rect := player_get_rect()

	debug_draw.emit(window_rect, own_rect)

	if window_rect.encloses(own_rect):
		finished.emit('previous')
		return

	# Otherwise detect which of the four sides are being touched
	var left: bool = own_rect.position.x < window_rect.position.x
	var right: bool = own_rect.position.x + own_rect.size.x > window_rect.position.x + window_rect.size.x

	var up: bool = own_rect.position.y < window_rect.position.y
	var down: bool = own_rect.position.y + own_rect.size.y > window_rect.position.y + window_rect.size.y

	if (left):
		print("left")
	if (right):
		print("right")
	if (up):
		print("up")
	if (down):
		print("down")


func exit() -> void:
	var animation_player := owner.get_node(^"AnimationPlayer")
	animation_player.play(old_animation)
	owner.resizing_window = false
	
