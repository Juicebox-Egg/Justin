extends Node2D

# References the player, animation system, sprite, and wall-jump raycast.
@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
@export var raycast: Node

# Values used to determine which direction the player is facing.
const DIRECTION_RIGHT := 1
const DIRECTION_LEFT := -1
const VELOCITY_ZERO := 0.0

# Animation names used by the player's AnimationPlayer.
const ANIM_MOVE := "move"
const ANIM_IDLE := "idle"
const ANIM_JUMP := "jump_anim"
const ANIM_FALL := "fall"
const ANIM_DASH := "Dash"

# Input action used to activate the player's dash.
const INPUT_DASH := "dash"


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Flip the sprite horizontally to match the player's movement direction.
	if player_controller.direction == DIRECTION_RIGHT:
		sprite.flip_h = false
	elif player_controller.direction == DIRECTION_LEFT:
		sprite.flip_h = true

	# Flip the wall-jump raycast so it checks the side the player is facing.
	if player_controller.direction != raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction

	# Play the movement animation when the player is moving horizontally.
	if abs(player_controller.velocity.x) > VELOCITY_ZERO:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)

	# Choose the jump or fall animation based on vertical velocity.
	if player_controller.velocity.y < VELOCITY_ZERO:
		animation_player.play(ANIM_JUMP)
	elif player_controller.velocity.y > VELOCITY_ZERO:
		animation_player.play(ANIM_FALL)

	# Play the dash animation when the dash input is pressed.
	if Input.is_action_just_pressed(INPUT_DASH):
		animation_player.play(ANIM_DASH)
		await animation_player.animation_finished
