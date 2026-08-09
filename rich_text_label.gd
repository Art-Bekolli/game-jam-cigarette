extends RichTextLabel

@export_file("*.tscn") var next_scene_path: String = "res://level.tscn"
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
var skip_requested := false


func _ready():
	text = ""

	# Start the intro music
	var intro_music = get_parent().get_node_or_null("Intro")
	if intro_music:
		intro_music.play()

	show_next_line()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		# Space or Accept key skips typing / pauses
		if event.keycode == KEY_SPACE or event.is_action_pressed("ui_accept"):
			skip_requested = true
		# Escape key skips the entire intro scene immediately
		elif event.keycode == KEY_ESCAPE:
			change_scene()


func show_next_line():
	if current_line >= lines.size():
		change_scene()
		return

	typed_text = ""
	typing = true
	skip_requested = false

	var is_warning = current_line == lines.size() - 1

	for i in range(lines[current_line].length()):
		# If space was pressed, fill the text instantly
		if skip_requested:
			typed_text = lines[current_line]
			break

		typed_text = lines[current_line].substr(0, i + 1)

		if is_warning:
			text = "[color=#ff3333]" + typed_text + "▌[/color]"
		else:
			text = typed_text + "▌"

		var delay := typing_speed

		if is_warning:
			delay = 0.12

		if lines[current_line][i] == ".":
			delay *= 3.0
		elif lines[current_line][i] == ",":
			delay *= 2.0

		await get_tree().create_timer(delay).timeout

	typing = false
	skip_requested = false

	# Show completed line with cursor
	if is_warning:
		text = "[color=#ff3333]" + typed_text + "▌[/color]"
	else:
		text = typed_text + "▌"

	# Wait for pause duration OR skip immediately if Space is pressed again
	var elapsed := 0.0
	while elapsed < pause_between_lines and not skip_requested:
		await get_tree().process_frame
		elapsed += get_process_delta_time()

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


func change_scene():
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
