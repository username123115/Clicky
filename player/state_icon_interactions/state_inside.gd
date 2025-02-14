extends 'res://state.gd'

func update(delta: float):
	assert(owner.in_icon)
	if Input.is_action_just_pressed("grab"):
		owner.icon.click(owner)
