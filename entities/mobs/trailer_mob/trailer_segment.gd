extends Mob

@export var head: Mob

func deal_damage(amount: int) -> void:
	head.deal_damage(amount)
