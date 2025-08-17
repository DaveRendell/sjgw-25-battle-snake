extends Sprite2D

var from: Node2D
var to: Mob

func _physics_process(_delta: float) -> void:
	if not from or not to: return queue_free()
	
	var distance = from.position.distance_to(to.position)
	scale.x = distance / texture.get_width()
	position = (from.position + to.position) / 2
	rotation = (from.position - to.position).angle()
