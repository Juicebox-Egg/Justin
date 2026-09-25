extends Camera2D

# Controls how quickly the camera shake decreases over time.
@export var decay: float = 0.8

# Maximum horizontal and vertical distance the camera can move while shaking.
@export var max_offset: Vector2 = Vector2(100, 75)

# Maximum amount of rotation applied during the camera shake.
@export var max_roll: float = 0.1

# References the node that the camera follows.
@export var follow_node: Node2D

# Stores the current strength of the camera shake.
var trauma: float = 0.0

# Minimum and maximum values used to control the trauma strength.
const MIN_TRAUMA := 0.0
const MAX_TRAUMA := 1.0

# Controls how strongly trauma affects the intensity of the shake.
const TRAUMA_POWER := 2

# Amount of trauma added when the shake input is triggered.
const TRAUMA_AMOUNT := 0.2

# Minimum and maximum random values used for the shake direction.
const MIN := -1.0
const MAX := 1.0


func _input(event: InputEvent) -> void:
	# Add camera shake when the player presses the Shift key.
	if event is InputEventKey and event.pressed and event.keycode == KEY_SHIFT:
		add_trauma(TRAUMA_AMOUNT)


func _ready() -> void:
	# Randomise the values used to create unpredictable camera movement.
	randomize()


func _process(delta: float) -> void:
	# Continue shaking the camera while trauma remains.
	if trauma:
		# Gradually reduce the shake strength over time.
		trauma = max(trauma - decay * delta, MIN_TRAUMA)
		# Apply the current shake strength to the camera.
		shake()


func add_trauma(amount: float) -> void:
	# Increase the trauma without allowing it to exceed the maximum.
	trauma = min(trauma + amount, MAX_TRAUMA)


func shake() -> void:
	# Square the trauma value so stronger trauma produces a more intense shake.
	var amount = pow(trauma, TRAUMA_POWER)
	# Randomly rotate the camera based on the current shake intensity.
	rotation = max_roll * amount * randf_range(MIN, MAX)
	# Randomly move the camera horizontally and vertically based on the shake intensity.
	offset.x = max_offset.x * amount * randf_range(MIN, MAX)
	offset.y = max_offset.y * amount * randf_range(MIN, MAX)
