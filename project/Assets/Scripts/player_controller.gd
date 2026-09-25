extends CharacterBody2D
class_name PlayerController

# Gets the project's default gravity to apply to the player.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player movement settings that can be adjusted in the Inspector.
@export var speed: float = 10.0
@export var jump_power: float = 10.0
@export var player_animator: Node

# Input actions used to control the player.
const INPUT_JUMP := "jump"
const INPUT_MOVE_DOWN := "move_down"
const INPUT_MOVE_LEFT := "move_left"
const INPUT_MOVE_RIGHT := "move_right"
const INPUT_DASH := "dash"

# Groups and names used to identify the player and hazards.
const PLAYER_GROUP := "player"
const SPIKE_NAME := "Spikes"

# Basic horizontal movement settings.
const SPEED_MULTIPLIER: float = 20.0
const JUMP_MULTIPLIER: float = -30.0
var direction: float = 0.0

# Dash settings and state.
const DASH_SPEED: float = 40.0
var dashing: bool = false
var can_dash: bool = true

# Controls the delay and state used when the player respawns after taking damage.
const RESPAWN_DELAY: float = 0.3
const RESPAWN_RESET_DELAY: float = 0.1

var took_damage: bool = false
var can_move: bool = true
var is_respawning: bool = false
var is_dying: bool = false

# Settings for dropping through one-way platforms.
const DROP_THROUGH_DISTANCE: float = 1.0
const DROP_THROUGH_COLLISION_LAYER: int = 10

# Method name used to activate falling platforms.
const COLLIDE_METHOD := "collide_with"

# Normal jump and jump pad launch heights.
const JUMP_HEIGHT: float = -165.0
const JUMP_PAD_HEIGHT: float = -430.0

# Coyote jump settings allow the player to jump shortly after leaving a platform.
const COYOTE_FRAMES: int = 5
var coyote_jump: bool = false
var jumping: bool = false
var was_on_floor: bool = false
@onready var coyote_timer = $CoyoteTimer

# Raycast used to detect walls for wall jumping and wall sliding.
@onready var raycast = $Node2D/RayCast2D

# Wall jump and wall slide settings.
const WALL_JUMP_PUSHBACK: float = 100
const WALL_SLIDE_GRAVITY: float = 100
const WALL_GRAVITY_DIVISOR: float = 4.0
var is_wall_sliding: bool = false

# Horizontal movement added by conveyor platforms.
var conveyor_velocity: float = 0.0

# Checkpoint position used when the player respawns.
const NO_CHECKPOINT_POSITION := Vector2(-999, -999)
@export var player_checkpoint_position: Vector2 = NO_CHECKPOINT_POSITION


func _ready() -> void:
	# Convert the coyote jump duration from frames into seconds.
	coyote_timer.wait_time = float(COYOTE_FRAMES) / Engine.physics_ticks_per_second
	# Add the player to the group so other objects can identify it.
	add_to_group(PLAYER_GROUP)

	# Move the player to the saved checkpoint when one is active.
	if GlobalScript.checkpoint_position != NO_CHECKPOINT_POSITION:
		global_position = GlobalScript.checkpoint_position


func _input(event) -> void:
	# Handles jumping.
	# Allow the player to jump from the floor or during the coyote jump window.
	if event.is_action_pressed(INPUT_JUMP) and (is_on_floor() or coyote_jump):
		velocity.y = jump_power * JUMP_MULTIPLIER
		jumping = true

	# Handle dropping through one-way platforms.
	# Move the player slightly down and disable the platform collision.
	# This allows the player to drop through the platform.
	if event.is_action_pressed(INPUT_MOVE_DOWN) and is_on_floor():
		position.y += DROP_THROUGH_DISTANCE
		set_collision_mask_value(DROP_THROUGH_COLLISION_LAYER, false)
	else:
		# Re-enable the platform collision when the player is not dropping through it.
		set_collision_mask_value(DROP_THROUGH_COLLISION_LAYER, true)

	# Dash.
	# Start a dash if the player has a dash available.
	if Input.is_action_just_pressed(INPUT_DASH) and can_dash:
		dashing = true
		can_dash = false
		velocity.y = 0.0
		# Start the timers that control dash duration and dash recovery.
		$dash_timer.start()
		$dash_again.start()


# Moves the player to a checkpoint and resets their damage state.
func respawn(respawn_pos: Vector2) -> void:
	self.visible = false
	self.global_position = respawn_pos
	velocity = Vector2.ZERO
	self.visible = true
	can_move = true

	# Reset the player's animation after respawning.
	player_animator.reset_after_death()
	await get_tree().create_timer(RESPAWN_RESET_DELAY).timeout

	# Allow the player to take damage and respawn again.
	took_damage = false
	is_respawning = false


func _physics_process(delta: float) -> void:
	# Prevent movement while the player is dying or being respawned.
	if not can_move:
		velocity = Vector2.ZERO
		return

	# Handles gravity.
	# Apply gravity while the player is airborne.
	if not is_on_floor():
		if dashing:
			# Prevent gravity from affecting the player during a dash.
			velocity.y = 0.0
		elif raycast.is_colliding() and velocity.y > 0.0:
			# Reduce gravity while sliding down a wall.
			velocity += get_gravity() * delta / WALL_GRAVITY_DIVISOR
		else:
			# Apply normal gravity while falling.
			velocity += get_gravity() * delta

	jump()
	wall_slide(delta)


	# Spikes.
	# Detect collisions with spikes and begin the respawn process.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().name == SPIKE_NAME:
			if not took_damage and not is_respawning:
				took_damage = true
				is_respawning = true
				can_move = false

				# Stop movement and play the death animation before respawning.
				velocity = Vector2.ZERO
				player_animator.play_death()
				await get_tree().create_timer(RESPAWN_DELAY).timeout
				respawn(player_checkpoint_position)


	# Basic movement.
	# Get the player's horizontal movement direction.
	if not can_move:
		return
	else:
		direction = Input.get_axis(INPUT_MOVE_LEFT, INPUT_MOVE_RIGHT)
		if direction:
			if dashing:
				# Use the increased speed while dashing.
				velocity.x = direction * speed * DASH_SPEED
			else:
				# Use normal movement speed.
				velocity.x = direction * speed * SPEED_MULTIPLIER
		else:
			# Gradually slow the player when no movement input is held.
			velocity.x = move_toward(velocity.x, 0, speed * SPEED_MULTIPLIER)

	# Add conveyor movement to the player's horizontal velocity.
	velocity.x += conveyor_velocity
	move_and_slide()


	# Falling platform.
	# Detects if the falling platform has collided with the player or not.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.has_method(COLLIDE_METHOD):
			collider.call(COLLIDE_METHOD)


	# Coyote jump.
	# Reset the jumping state when the player lands.
	if is_on_floor() and jumping:
		jumping = false
	# Start the coyote jump timer when the player has just left the floor.
	if was_on_floor and not is_on_floor() and not jumping:
		coyote_jump = true
		coyote_timer.start()
	# Store the current floor state for the next physics frame.
	was_on_floor = is_on_floor()


# Handles normal jumps and wall jumps.
func jump() -> void:
	if Input.is_action_just_pressed(INPUT_JUMP):
		if is_on_floor():
			# Perform a normal jump when standing on the floor.
			velocity.y = jump_power * JUMP_MULTIPLIER

		if raycast.is_colliding() and Input.is_action_pressed(INPUT_MOVE_RIGHT):
			# Jump away from a wall on the player's right.
			velocity.y = jump_power * JUMP_MULTIPLIER
			velocity.x = -WALL_JUMP_PUSHBACK

		if raycast.is_colliding() and Input.is_action_pressed(INPUT_MOVE_LEFT):
			# Jump away from a wall on the player's left.
			velocity.y = jump_power * JUMP_MULTIPLIER
			velocity.x = WALL_JUMP_PUSHBACK


# Wall slide.
# Determines whether the player should be wall sliding.
func wall_slide(delta: float) -> void:
	if raycast.is_colliding() and not is_on_floor():
		# Wall sliding begins when the player is airborne and presses toward the wall.
		if Input.is_action_just_pressed(INPUT_MOVE_LEFT) or Input.is_action_just_pressed(INPUT_MOVE_RIGHT):
			is_wall_sliding = true
		else:
			# Disable wall sliding when there is no suitable wall collision.
			is_wall_sliding = false
	else:
		is_wall_sliding = false


# Stop the current dash when the dash timer expires.
func _on_dash_timer_timeout() -> void:
	dashing = false


# Allow the player to dash again after the recovery timer expires.
func _on_dash_again_timeout() -> void:
	can_dash = true


# End the coyote jump window when its timer expires.
func _on_coyote_timer_timeout() -> void:
	coyote_jump = false
