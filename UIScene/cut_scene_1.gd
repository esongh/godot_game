extends CutScene

@export var time_line : Resource
@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(_animation_finished)
	animation_player.play(&"movie")

func _animation_finished(strName : String) -> void:
	if (strName == "movie"):
		if Dialogic.current_timeline != null:
			return
		Dialogic.timeline_ended.connect(on_timeline_ended)
		Dialogic.start(time_line)
	if (strName == "lost"):
		cut_scene_ended.emit.call_deferred()

func on_timeline_ended() -> void:
	animation_player.play(&"lost")
