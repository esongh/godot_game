extends Node
class_name Dialogues

signal dialogue_end

class StatesLog:
	var scenario
	var position
	var label
	var animation
	var ended : bool

	func _init(
		text_label: RichTextLabel,
		aAnimation: AnimationPlayer
	) -> void:
		self.label = text_label
		self.animation = aAnimation

	func run(
		aScenario: Dictionary,
		scene: String
	) -> void:
		self.scenario = aScenario[scene]
		self.position = 0
		self.ended = false
		var text = self.scenario[self.position]
		if text == "*start*":
			self.next()

	func next() -> void:
		if self.animation.current_animation == "text":
			self.skip_animation()
			return
		var _position = self.position + 1
		var _text = self.scenario[_position]
		if _text == "*end*":
			self.ended = true
			return
		if typeof(_text) == TYPE_ARRAY:
			var _scene_act = _text[1]
			_text = _text[0]
		self.play_text(_text)
		self.position = _position

	func play_text(data) -> void:
		self.label.text = data
		self.animation.play("text")

	func skip_animation() -> void:
		self.animation.seek(1.1, true)
