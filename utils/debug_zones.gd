extends Label

var cm : CameraManager

func _ready() -> void:
	cm = get_parent().get_node(^"CameraMan")

func _process(delta : float) -> void:
	if not cm:
		cm = get_parent().get_node(^"CameraMan")

	text = str(cm.zone_queue)
