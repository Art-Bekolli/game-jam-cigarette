extends RichTextLabel

@export var typing_speed := 0.045
@export var pause_between_lines := 2.0
@export var cursor_speed := 0.5

var lines = [
	"You've been out partying all night. It's been fun, it's been long, you only live once, right?",
	"...",
	"Oh no...",
	"The party has run out of cigarettes. And worse than that, you've been chosen to go get more.",
	"And so, armed with the last few cigs from the party, you venture out into the night.",
	". . . Be Wary Of Strangers . . ."
]

var current_line := 0
var typed_text := ""
var typing := false


func _ready():
	text = ""

	# Start the intro music
	var intro_music = get_parent().get_node_or_null("Intro")
	if intro_music:
		intro_music.play()

	show_next_line()


func show_next_line():
	if current_line >= lines.size():
		return

	typed_text = ""
	typing = true

	var is_warning = current_line == lines.size() - 1

	for i in range(lines[current_line].length()):
		typed_text = lines[current_line].substr(0, i + 1)

		# Always use BBCode, so there is no blue flash
		if is_warning:
			text = "[color=#ff3333]" + typed_text + "▌[/color]"
		else:
			text = typed_text + "▌"

		var delay := typing_speed

		# Final warning types much slower
		if is_warning:
			delay = 0.12

		# Punctuation pauses
		if lines[current_line][i] == ".":
			delay *= 3.0
		elif lines[current_line][i] == ",":
			delay *= 2.0

		await get_tree().create_timer(delay).timeout

	typing = false

	# Keep cursor visible after typing
	if is_warning:
		text = "[color=#ff3333]" + typed_text + "▌[/color]"
	else:
		text = typed_text + "▌"

	await get_tree().create_timer(pause_between_lines).timeout

	current_line += 1
	show_next_line()


func _process(_delta):
	if typing:
		return

	if current_line >= lines.size():
		return

	var blink := fmod(Time.get_ticks_msec() / 1000.0, cursor_speed * 2.0) < cursor_speed

	var is_warning = current_line == lines.size() - 1

	if is_warning:
		if blink:
			text = "[color=#ff3333]" + typed_text + "▌[/color]"
		else:
			text = "[color=#ff3333]" + typed_text + "[/color]"
	else:
		if blink:
			text = typed_text + "▌"
		else:
			text = typed_text
