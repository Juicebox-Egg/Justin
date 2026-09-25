extends Node2D

# References the player and the nodes used to control its animations and direction.
@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
@export var raycast: RayCast2D
@export var player_animator: Node

# Tracks whether a dash or death animation is currently playing.
var is_dashing = false
var is_dying = false

# Values used to determine which direction the player is facing.
const DIRECTION_RIGHT := 1
const DIRECTION_LEFT := -1
const VELOCITY_ZERO := 0.0

# Animation names used by the AnimationPlayer.
const ANIM_DASH := "dash_anim"
const ANIM_DEATH := "death_anim"
const ANIM_MOVE := "move"
const ANIM_IDLE := "idle"
const ANIM_JUMP := "jump_anim"
const ANIM_FALL := "fall"

# Input action used to activate the player's dash.
const INPUT_DASH := "dash"


func _ready() -> void:
	# Listen for when an animation finishes so dash and death states can be reset.
	animation_player.animation_finished.connect(_on_animation_finished)


# Starts the death animation and prevents the dash state from remaining active.
func play_death() -> void:
	is_dying = true
	is_dashing = false
	animation_player.play(ANIM_DEATH)


func _on_animation_finished(anim_name) -> void:
	# Allow normal animations to resume after the dash finishes.
	if anim_name == ANIM_DASH:
		is_dashing = false

	# Allow normal animations to resume after the death animation finishes.
	if anim_name == ANIM_DEATH:
		is_dying = false


# Resets animation states after the player has finished dying.
func reset_after_death() -> void:
	is_dying = false
	is_dashing = false

	# Return to the appropriate movement or idle animation.
	if abs(player_controller.velocity.x) > VELOCITY_ZERO:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)


func _process(delta: float) -> void:
	# Flip the player sprite to match the direction of movement.
	if player_controller.direction == DIRECTION_RIGHT:
		sprite.flip_h = false
	elif player_controller.direction == DIRECTION_LEFT:
		sprite.flip_h = true

	# Flip the wall jump raycast so it checks the side the player is facing.
	if player_controller.direction != raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction

	# Start the dash animation when the dash input is pressed.
	if Input.is_action_just_pressed(INPUT_DASH) and not is_dying:
		is_dashing = true
		animation_player.play(ANIM_DASH)
		return

	# Prevent movement animations from interrupting the dash animation.
	if is_dashing:
		return

	# Prevent movement animations from overriding the death animation.
	if is_dying:
		return

	# Play the movement animation when the player is moving horizontally.
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)

	# Override the movement animation when the player is jumping or falling.
	if player_controller.velocity.y < 0.0:
		animation_player.play(ANIM_JUMP)
	elif player_controller.velocity.y > 0.0:
		animation_player.play(ANIM_FALL)
