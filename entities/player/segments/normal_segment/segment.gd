class_name Segment extends Node2D

var player: Player

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if not body.get_parent() is Mob: return
	
	var mob: Mob = body.get_parent()
	mob.deal_damage(3)
