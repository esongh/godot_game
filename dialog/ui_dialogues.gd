extends Dialogues

@onready var text_label : RichTextLabel = $Control/Label
@onready var animation : AnimationPlayer = $AnimationPlayer

const scenario = {
	"example": [
		"*start*",
		"你好，我是凌木",
		"你好呀，凌木，我是云星。你来自哪里呀~",
		"*end*"
	]
}

var states : StatesLog

func _ready() -> void:
	states = StatesLog.new(
		text_label,
		animation
	)
	print("states run")
	states.run(scenario, "example")

func _input(event) -> void:
	if Input.is_action_just_pressed(&"ui_accept"):
		states.next()
	if states.ended:
		queue_free()
