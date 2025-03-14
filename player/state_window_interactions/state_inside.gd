extends 'rectangle.gd'

func update(_delta: float):
	assert(owner.in_window)
	var window_rect := owner.window.window_get_rect() as Rect2
	var own_rect := player_get_rect()

	if window_rect.encloses(own_rect):
		pass
	else:
		owner.window_move = false
		if not owner.in_icon:
			finished.emit('resize')
		return

	if not owner.in_icon and Input.is_action_just_pressed("grab"):
		finished.emit('moving')
		return
		#owner.window_move = true
		#owner.window.focus()
	else:
		owner.window_move = false

func exit():
	owner.window_move = false
