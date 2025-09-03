extends CutScene

func _ready() -> void:
	$Timer.start(2)

func on_timeout() -> void:
	if Dialogic.current_timeline != null:
		return
	Dialogic.timeline_ended.connect(on_timeline_ended)
	Dialogic.start("res://dialog/Timeline/cut_scene_2.dtl")

func on_timeline_ended() -> void:
	cut_scene_ended.emit.call_deferred()
