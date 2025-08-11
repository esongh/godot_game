class_name BlockingDoor

extends Interactable

var opened: bool = false
var can_open: bool = false
@onready var note_timer := $ShowNoteTimer as Timer
@onready var note_panel := $Panel as Panel

func _ready() -> void:
	note_panel.visible = false

func interact() -> void:
	if opened:
		return
	if not can_open:
		show_note()
	else:
		open()

func open() -> void:
	if opened:
		return
	opened = true
	interactable = false
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation_degrees", -90, 2.5)

func show_note() -> void:
	print("You need to collect all the fruits first!")
	note_panel.visible = true
	note_timer.timeout.connect(func() -> void:
		note_panel.visible = false
	)
	note_timer.start(3.0)

func _on_all_pickups_collected() -> void:
	can_open = true
