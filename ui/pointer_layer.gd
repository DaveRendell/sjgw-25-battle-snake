class_name PointerLayer extends CanvasLayer

@export var player: Node2D
@export var target: Node2D
@export var sub_viewport: SubViewport
@export var colour: Color
@export var label_text: String

@onready var triangle: Triangle = $Triangle
@onready var label_container: Node2D = $LabelContainer
@onready var label: Label = $LabelContainer/Label

var point_vector: Vector2

func _ready() -> void:
	triangle.color = colour
	triangle.outline_color = colour
	label.add_theme_color_override("font_color", colour)
	label.text = label_text

func _physics_process(_delta: float) -> void:
	if not target: return
	if not player: return
	var origin: Vector2 = player.position
	var pointer_direction: Vector2 = (target.position - origin).normalized()
	
	# If it hits the top / bottom, what's the scaling factor?
	var distance_to_edge = (sub_viewport.size.y / 2 - 8)
	var scale_v = distance_to_edge / pointer_direction.y
	# If it hits the left / right, what's the scaling factor?
	distance_to_edge = (sub_viewport.size.x / 2 - 8)
	var scale_h = distance_to_edge / pointer_direction.x
	
	var scale_factor = min(abs(scale_v), abs(scale_h))
	point_vector = scale_factor * pointer_direction
	
	triangle.position = point_vector + 0.5 * sub_viewport.size
	triangle.rotation = pointer_direction.rotated(TAU / 4).angle()

	label_container.position = point_vector + 0.5 * sub_viewport.size - 24 * pointer_direction + 16 * Vector2.LEFT
	
	if point_vector.length() > (target.position - origin).length() - 72:
		hide()
	else:
		show()
