extends 'res://state.gd'

func player_get_rect() -> Rect2:
	var pos := owner.get_global_position() as Vector2
	var size := owner.get_node(^"CollisionShape2D").shape.size as Vector2
	var r := Rect2()
	r.position = pos - size / 2.0
	r.size = size
	return r
