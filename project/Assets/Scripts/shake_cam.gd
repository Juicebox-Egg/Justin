extends Camera2D

@export var decay : float = 0.8
@export var max_offset : Vector2 = Vector2(100,75)
@export var max_roll: float = 0.1
@export var follow_node : Node2D

var trauma : float = 0.0

const MIN_TRAUMA := 0.0
const MAX_TRAUMA := 1.0
const TRAUMA_POWER := 2
const TRAUMA_AMOUNT := 0.2
const MIN := -1.0
const MAX := 1.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SHIFT:
		add_trauma(TRAUMA_AMOUNT)

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, MIN_TRAUMA)
		shake()
		
func add_trauma(amount: float) -> void:
	trauma = min (trauma+amount, MAX_TRAUMA)


func shake() -> void:
	var amount = pow(trauma, TRAUMA_POWER)
	rotation = max_roll * amount * randf_range(MIN, MAX)
	offset.x = max_offset.x * amount * randf_range(MIN, MAX)
	offset.y = max_offset.y * amount * randf_range(MIN, MAX)
