@tool
extends Node2D

var label : RichTextLabel
var video : VideoStreamPlayer

# Thanks webfx.com! Now I'm bound to be a cool kid
var words := ["Cap", "No cap", "Caught in 4K", "Cringey", "Cringe", "Dead", "Fam", "Fire", "Flex", "Ghost",
"Goat", "Gucci", "Highkey", "Lowkey", "L", "W", "Mid", "Mood", "Shook", "Stan", "Tea", "Throw shade", "Troll"]

var accum: float = 0

var text := """
So I (74M) was recently hit by a car (2014 Honda) and died. My wife (5F) organized me a funeral (cost $2747) without asking me (74M) at all. I (74M) was unable to make it because I (74M) was dead (17 days). At the funeral I heard my dad (15M) and other family members talking about how they wish I could be there and now I feel bad for not showing up. AITA?
"""

var split := text.split(" ")
var index := 0
var max_length := len(split)

@export var word_period : float = 0.25
@export var max_words : int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		print("FOCUS ")
		video = get_node(^"VideoStreamPlayer")
		label = get_node(^"Label Origin/Label")

		var video_file = load("brainrot.ogv")
		video.stream = video_file
		video.loop = true
		video.audio_track = -1
		video.play()
		label.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		accum += delta
		if (accum >= word_period):
			do_word()
			accum = 0.0
		pass

func do_word() -> void:
	var count := randi() % (max_words - 1)
	count += 1

	var start := index
	var end := index + count
	if (end >= max_length):
		index = 0
		end = max_length - 1
	else:
		index = end
	
	var slice := split.slice(start, end)

	var s := " ".join(slice)
	label.text = "\n[wave amp=100.0 freq=5.0 connected=1][center]%s[/center][/wave]" % s
