extends CutScene

@export var time_line : Resource
@onready var animation := $AnimationPlayer

func _ready() -> void:
	animation.animation_finished.connect(_animation_finished)
	animation.play(&"movie")

func _animation_finished(strName : String) -> void:
	if (strName == "movie"):
		if Dialogic.current_timeline != null:
			return
		Dialogic.timeline_ended.connect(on_timeline_ended)
		Dialogic.start(time_line)
	if (strName == "lost"):
		cut_scene_ended.emit.call_deferred()

func on_timeline_ended() -> void:
	animation.play(&"lost")
