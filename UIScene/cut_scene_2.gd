extends CutScene

@export var time_line : Resource
@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)
	animation_player.play(&"meet_under_tree")

func on_animation_finished(str_name : String) -> void:
	if (str_name == "meet_under_tree"):
		if Dialogic.current_timeline != null:
			return
		Dialogic.timeline_ended.connect(on_timeline_ended)
		Dialogic.start(time_line)
	else:
		cut_scene_ended.emit.call_deferred()

func on_timeline_ended() -> void:
	cut_scene_ended.emit.call_deferred()
