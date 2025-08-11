extends ParallaxLayer

func _process(delta: float) -> void:
	position.x -= 40 * delta
