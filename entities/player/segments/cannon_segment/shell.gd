class_name Shell extends Node2D

@export var velocity: Vector2

func _physics_process(delta: float) -> void:
	position += delta * velocity

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() is not Mob: return
	var mob: Mob = body.get_parent()
	mob.deal_damage(1)
	queue_free()
