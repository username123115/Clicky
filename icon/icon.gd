extends Node2D

@onready var sprite : Sprite2D = $DefaultSprite
@onready var area : Area2D = $DefaultArea

@onready var click_interval_timer : Timer = $"Click Interval Timer"
@onready var click_consecutive_timer : Timer = $"Click Consecutive Timer"

@export var click_interval : float = 0.05						#how long icon will flash white/ unable to click
@export var click_consecutive_interval : float = 0.3			#period between clicks that will add to click_count

var clicker_count = 0
var click_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var test_sprite : Sprite2D = get_node(^"Sprite2D")
	var test_area : Area2D = get_node(^"Area2D")

	if (test_sprite and test_area):
		sprite.queue_free()
		area.queue_free()

		sprite = test_sprite
		area = test_area
	else:
		sprite.visible = true
		area.visible = true
		if test_area:
			test_area.queue_free()
		if test_sprite:
			test_sprite.queue_free()

	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

	click_interval_timer.one_shot = true
	click_consecutive_timer.one_shot = true

	click_interval_timer.connect("timeout", _on_click_interval_timer_timeout)
	click_consecutive_timer.connect("timeout", _on_click_consecutive_timer_timeout)

func _process(delta: float):
	if click_interval_timer.is_stopped():
		if clicker_count == 0:
			sprite.self_modulate.a = 1.0
		else:
			sprite.self_modulate.a = 0.8

func click(clicker = null) -> void:
	# Only click if haven't clicked in last click_interval seconds
	if click_interval_timer.is_stopped():
		click_count += 1

		sprite.self_modulate.r = 4.0
		sprite.self_modulate.g = 4.0
		sprite.self_modulate.b = 4.0

		click_interval_timer.stop()
		click_interval_timer.start(click_interval)

		click_consecutive_timer.stop()
		click_consecutive_timer.start(click_consecutive_interval)
		
		print(click_count)

# stop clicking
func _on_click_interval_timer_timeout():
	sprite.self_modulate.r = 1.0
	sprite.self_modulate.g = 1.0
	sprite.self_modulate.b = 1.0

func focus(clicker = null):
	clicker_count += 1
	
func onfocus(clicker = null):
	clicker_count = max(0, clicker_count - 1)

func _on_click_consecutive_timer_timeout():
	click_count = 0

func _on_body_entered(body) -> void:
	EventBus.emit_signal("icon_body_entered", body)

func _on_body_exited(body) -> void:
	EventBus.emit_signal("icon_body_exited", body)
