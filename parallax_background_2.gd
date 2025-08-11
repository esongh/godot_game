extends ParallaxBackground

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	scroll_offset.x -= 40 * delta
