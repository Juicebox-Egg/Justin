extends Path2D
class_name MovingPlatform

# Controls how long the platform takes to travel along the path.
@export var path_time: float = 1.0

# Determines whether the platform travels back and forth continuously.
@export var looping: bool = false

# Controls the acceleration and deceleration of the platform's movement.
@export var easing: Tween.EaseType

# Controls the overall transition style of the platform's movement.
@export var transition: Tween.TransitionType

# References the PathFollow2D that moves the platform along this path.
@export var path_follow_2d: PathFollow2D

# Progress values representing the start and end of the path.
const PATH_START := 0.0
const PATH_END := 1.0

# Instantly returns the platform to the start.
const NO_DURATION := 0.0


func _ready() -> void:
	# Find the PathFollow2D automatically if it was not assigned in the Inspector.
	if path_follow_2d == null:
		path_follow_2d = get_node_or_null("PathFollow2D")

	# Start the platform's movement when the scene loads.
	if path_follow_2d != null:
		move_tween()


func move_tween() -> void:
	# Create a tween that repeatedly controls the platform's path movement.
	var tween = get_tree().create_tween().set_loops()

	# Move the platform from the start to the end of the path.
	tween.tween_property(
		path_follow_2d,
		"progress_ratio",
		PATH_END,
		path_time
	).set_ease(easing).set_trans(transition)

	if looping:
		# Move back to the start so the platform travels back and forth.
		tween.tween_property(
			path_follow_2d,
			"progress_ratio",
			PATH_START,
			path_time
		).set_ease(easing).set_trans(transition)
	else:
		# Instantly return to the start so the movement can repeat from the beginning.
		tween.tween_property(
			path_follow_2d,
			"progress_ratio",
			PATH_START,
			NO_DURATION
		).set_ease(easing).set_trans(transition)
