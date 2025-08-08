class_name Trail extends Node

@onready var _parent: Node2D = get_parent()

var _circular_buffer := PackedVector2Array()
@export var _buffer_length: int = 150
var _pointer: int = _buffer_length - 1
@export var initial_direction: Vector2 = Vector2.RIGHT
@export var _initial_step: float = 0.5

var head: Vector2:
	get(): return _circular_buffer[_pointer]

func _ready() -> void:
	for i in _buffer_length:
		_circular_buffer.append(_parent.position - (_buffer_length - i) * _initial_step * initial_direction)
	print(_circular_buffer)

# Returns the point in the trail that is a set distance from the start point of the trail
# Returns a point relative to the parent's parent, usually the root scene
func get_point_distance_from_trail(distance: float) -> Vector2:
	var test_pointer = posmod(_pointer - 1, _buffer_length)
	var travelled_distance: float = 0.0
	
	while travelled_distance < distance:
		var last_point = _circular_buffer[test_pointer]
		test_pointer = posmod(test_pointer - 1, _buffer_length)
		var next_point = _circular_buffer[test_pointer]
		travelled_distance += last_point.distance_to(next_point)
		
		if test_pointer == _pointer:
			test_pointer = posmod(_pointer + 1, _buffer_length)
			break
	
	return _circular_buffer[test_pointer]

func _physics_process(_delta: float) -> void:
	# Add current parent position to circular buffer
	_circular_buffer.set(_pointer, _parent.position)
	_pointer = posmod(_pointer + 1, _buffer_length)
