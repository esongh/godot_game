extends CanvasLayer

signal cut_scene_ended

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(_animation_finished)

func _animation_finished(_strName : String) -> void:
	if Dialogic.current_timeline != null:
		return
	Dialogic.timeline_ended.connect(on_timeline_ended)
	Dialogic.start("res://dialog/Timeline/timeline_1.dtl")

func on_timeline_ended() -> void:
	cut_scene_ended.emit()
