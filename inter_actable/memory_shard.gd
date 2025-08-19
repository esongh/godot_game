extends Interactable

class_name MemoryShard

@export var animationPlayer : AnimatedSprite2D
@export var animationName : String

func _ready() -> void:
	animationPlayer.play(animationName)

func interact() -> void:
	if animationPlayer.is_playing():
		animationPlayer.stop()
	else:
		animationPlayer.play(animationName)
