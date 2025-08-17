class_name FlamethrowerSegment extends Segment
@onready var flames_1: GPUParticles2D = $Flames1
@onready var flames_2: GPUParticles2D = $Flames2
@onready var flame_box_1: Area2D = $FlameBox1
@onready var flame_box_2: Area2D = $FlameBox2

var _flames_on = false

func _ready() -> void:
	turn_off_flames()

func run_flames() -> void:
	SfxManager.play_flames()
	flames_1.emitting = true
	flames_2.emitting = true
	_flames_on = true

func turn_off_flames() -> void:
	flames_1.emitting = false
	flames_2.emitting = false
	_flames_on = false

func _on_timer_timeout() -> void:
	if _flames_on: turn_off_flames()
	else: run_flames()


func _on_hit_timer_timeout() -> void:
	if not _flames_on: return
	var mobs_on_fire = flame_box_1.get_overlapping_bodies()
	mobs_on_fire.append_array(flame_box_2.get_overlapping_bodies())
	for mob_hitbox in mobs_on_fire:
		var mob: Mob = mob_hitbox.get_parent()
		mob.deal_damage(1)
	
