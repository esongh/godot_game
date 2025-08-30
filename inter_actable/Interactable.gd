class_name Interactable

extends Area2D
signal interacted

var interactable : bool = true

func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func interact() -> void:
	print("%s acting..." % name)
	interacted.emit()

func _on_body_entered(body: Node) -> void:
	if body.name != "Mu-xing":
		return
	if not interactable:
		return
	body.register_interactable(self)

func _on_body_exited(body: Node) -> void:
	if body.name != "Mu-xing":
		return
	body.unregister_interactable(self)
