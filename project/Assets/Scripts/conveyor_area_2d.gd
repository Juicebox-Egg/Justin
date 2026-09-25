extends Area2D
class_name ConveyorArea2D

const NO_CONVEYOR_SPEED := 0.0
const CONVEYOR_VELOCITY := "conveyor_velocity"

# Controls how quickly objects are moved horizontally.
@export var horizontal_speed: float = 1.0

# Stores objects inside the conveyor and their current conveyor speeds.
var objects_array: Array[Node2D] = []
var objects_speed: Array[float] = []


func _ready() -> void:
	# Disable physics processing until an object enters the conveyor.
	set_physics_process(false)

	# Connect signals to detect objects entering and leaving the conveyor.
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)


func _physics_process(delta: float) -> void:
	# Apply conveyor movement only while objects are standing on the floor.
	for i in objects_array.size():
		if objects_array[i].is_on_floor() and objects_speed[i] != horizontal_speed:
			# Add the conveyor speed when the object is on the floor.
			objects_array[i].conveyor_velocity += horizontal_speed
			objects_speed[i] = horizontal_speed

		elif not objects_array[i].is_on_floor() and objects_speed[i] != NO_CONVEYOR_SPEED:
			# Remove the conveyor speed while the object is airborne.
			objects_array[i].conveyor_velocity -= horizontal_speed
			objects_speed[i] = NO_CONVEYOR_SPEED


func _object_entered(object: Node2D) -> void:
	# Only track objects that have a conveyor_velocity variable.
	if CONVEYOR_VELOCITY in object:
		objects_array.append(object)
		objects_speed.append(NO_CONVEYOR_SPEED)

	# Start physics processing when an object is inside the conveyor.
	if not objects_array.is_empty():
		set_physics_process(true)


func _object_exited(object: Node2D) -> void:
	# Remove the object from the conveyor when it leaves its area.
	if CONVEYOR_VELOCITY in object and objects_array.has(object):
		var object_pos: int = objects_array.find(object)

		# Remove the conveyor's movement before removing the object.
		if objects_speed[object_pos] != NO_CONVEYOR_SPEED:
			objects_array[object_pos].conveyor_velocity -= horizontal_speed

		# Remove the object and its stored speed from the arrays.
		objects_array.remove_at(object_pos)
		objects_speed.remove_at(object_pos)

	# Stop physics processing when there are no objects left.
	if objects_array.is_empty():
		set_physics_process(false)
