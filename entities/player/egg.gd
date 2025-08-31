class_name Egg extends Pickup
signal hatched

func pickup(player) -> void:
	hatched.emit()
