extends CharacterBody2D

# Controls the platform's shake animations.
@onready var animation_player = $AnimationPlayer

# Controls how long the platform shakes, falls, and stays hidden.
@export var reset_time: float = 1.0
@export var shake_time: float = 0.5
@export var fall_time: float = 0.2

# Collision value used to disable the platform's collision.
const DISABLED_COLLISION := 0

# Tracks whether the platform has already been triggered.
var is_triggered = false

# Gets the project's default gravity so the platform falls naturally.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Stores the platform's starting position for when it resets.
@onready var reset_position = global_position

# Stores the original collision settings so they can be restored after resetting.
var original_collision_layer
var original_collision_mask

# Animation used to shake the platform.
const SHAKE := "shake"


func _ready() -> void:
	# Disable physics until the platform is triggered by the player.
	set_physics_process(false)
	# Save the original collision settings before they are changed.
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask


func _physics_process(delta: float) -> void:
	# Apply gravity and move the platform downward.
	velocity.y += gravity * delta
	move_and_slide()


func collide_with() -> void:
	# Prevent the platform from being triggered multiple times at once.
	if is_triggered:
		return

	is_triggered = true
	velocity = Vector2.ZERO

	# Shake the platform first to warn the player that it is about to fall.
	animation_player.play(SHAKE)
	await get_tree().create_timer(shake_time).timeout

	# Stop the sequence if the platform was reset during the shake.
	if not is_triggered:
		return

	# Enable physics so the platform begins falling.
	set_physics_process(true)

	# Allow the platform to fall for the specified duration.
	await get_tree().create_timer(fall_time).timeout

	# Stop the platform and hide it after it has fallen.
	set_physics_process(false)
	velocity = Vector2.ZERO
	visible = false

	# Disable collision so the hidden platform cannot interact with the player.
	collision_layer = DISABLED_COLLISION
	collision_mask = DISABLED_COLLISION

	# Keep the platform hidden for the specified reset time.
	await get_tree().create_timer(reset_time).timeout

	# Return the platform to its original position.
	global_position = reset_position
	# Restore the collision settings saved when the scene started.
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	# Make the platform visible and ready to be triggered again.
	visible = true
	is_triggered = false
