extends Node

class_name PickUpManager

var pick_ups : Array[Fruit]

signal all_pickups_collected

func _ready() -> void:
	for pick_up in pick_ups:
		pick_up.picked_up.connect(_on_pick_up_interacted)

func _on_pick_up_interacted(pick_up: Fruit) -> void:
	pick_ups.erase(pick_up)
	if pick_ups.size() == 0:
		all_pickups_collected.emit()
