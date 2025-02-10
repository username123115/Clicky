extends 'rectangle.gd'


func update(_delta: float):
	assert(owner.in_window)
	var window_rect := owner.window.window_get_rect() as Rect2
	var own_rect := player_get_rect()

	if window_rect.encloses(own_rect):
		return
	else:
		finished.emit('resize')
