extends CharacterBody2D
class_name PlayerController

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# export variables
@export var speed : float = 10.0
@export var jump_power : float = 10.0
@export var player_animator : Node

# Input constants and groups
const INPUT_JUMP := "jump"
const INPUT_MOVE_DOWN := "move_down"
const INPUT_MOVE_LEFT := "move_left"
const INPUT_MOVE_RIGHT := "move_right"
const INPUT_DASH := "dash"

const PLAYER_GROUP := "player"
const SPIKE_NAME := "Spikes"

# basic player movement
const speed_multiplier : float = 20.0
const jump_multiplier : float = -30.0
var direction : float = 0.0

# simple dash
const dash_speed : float = 40.0
var dashing : bool = false
var can_dash : bool = true

# spikes
const respawn_delay : float = 0.3
const respawn_reset_delay : float = 0.1

var took_damage : bool = false
var can_move : bool = true
var is_respawning : bool = false
var is_dying : bool = false

# moving down platform
const drop_through_distance : float = 1.0
const drop_through_collision_layer: int = 10

# falling platforms
const collide_method := "collide_with"

# jump pad
const jump_height: float = -165.0
const jump_pad_height: float = -430.0

# coyote jump
var coyote_jump: bool = false
var jumping: bool = false
const coyote_frames: int = 5
var was_on_floor: bool = false
@onready var coyote_timer = $CoyoteTimer

# wall jump raycast
@onready var raycast = $Node2D/RayCast2D

# wall jump & wall slide
const wall_jump_pushback : float = 100
const wall_slide_gravity : float = 100
var is_wall_sliding : bool = false
const wall_gravity_divisor: float = 4.0

# conveyor platform
var conveyor_velocity: float = 0.0

# checkpoint
const no_checkpoint_position := Vector2(-999, -999)
@export var player_checkpont_pos: Vector2 = no_checkpoint_position

# coyote framerate
func _ready() -> void:
	coyote_timer.wait_time = (float(coyote_frames) / Engine.physics_ticks_per_second)
	add_to_group(PLAYER_GROUP)
	
	if GlobalScript.checkpoint_pos != no_checkpoint_position:
		global_position = GlobalScript.checkpoint_pos

func _input(event) -> void:
# Handle jump.
	if event.is_action_pressed(INPUT_JUMP) and (is_on_floor() or coyote_jump):
		velocity.y = jump_power * jump_multiplier 
		jumping = true
	# Handle jump down platform
	if event.is_action_pressed(INPUT_MOVE_DOWN) and is_on_floor():
		position.y += drop_through_distance
		set_collision_mask_value(drop_through_collision_layer, false)
	else:
		set_collision_mask_value(drop_through_collision_layer, true)

# dash
	if Input.is_action_just_pressed(INPUT_DASH) and can_dash:
		dashing = true
		can_dash = false
		velocity.y = 0.0
		$dash_timer.start()
		$dash_again.start()
		

# Respawn
func respawn(respawn_pos: Vector2) -> void:
	self.visible = false
	self.global_position = respawn_pos
	velocity = Vector2.ZERO
	self.visible = true
	can_move = true
	
	player_animator.reset_after_death()
	await get_tree().create_timer(respawn_reset_delay).timeout
	took_damage = false
	is_respawning = false


func _physics_process(delta: float) -> void:
# Stops the player from moving while dying/respawning
	if not can_move:
		velocity = Vector2.ZERO
		return
		
# Handles gravity
	if not is_on_floor():
		if dashing:
			velocity.y = 0.0
		elif raycast.is_colliding() and velocity.y > 0.0:
			velocity += get_gravity() * delta / wall_gravity_divisor
		else:
			velocity += get_gravity() * delta
			
	jump()
	wall_slide(delta)

# Spikes
# Detects whether the player has collided with spikes.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_collider().name == SPIKE_NAME:
			if not took_damage and not is_respawning:
				took_damage = true
				is_respawning = true
				can_move = false
				
				velocity = Vector2.ZERO
				player_animator.play_death()
				await get_tree().create_timer(respawn_delay).timeout
				respawn(player_checkpont_pos)

# Basic Movement
# the velocity/speed for the player to move left and right.
# This also includes the dash's speed being multiplied by the base moving speed.
	if can_move == false:
		return
	else:
		direction = Input.get_axis(INPUT_MOVE_LEFT, INPUT_MOVE_RIGHT)
		if direction:
			if dashing:
				velocity.x = direction * speed * dash_speed
			else:
				velocity.x = direction * speed * speed_multiplier
		else:
			velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		
# Conveyor Platform
	velocity.x += conveyor_velocity
	move_and_slide()
	
# Falling platform
# Detects if the falling platform has collided with the player or not.
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.has_method(collide_method):
			collider.call(collide_method)

# Coyote Jump
# Gives a small window of time even after fully stepping off a platform to jump.
	if is_on_floor() and jumping:
		jumping = false
	if was_on_floor and !is_on_floor() and not jumping:
		coyote_jump = true
		coyote_timer.start()
	was_on_floor = is_on_floor()

# Wall Jump
# The raycast detects and determines a wall, allowing whether the player can walljump.
func jump() -> void:
	if Input.is_action_just_pressed(INPUT_JUMP):
		if is_on_floor():
			velocity.y = jump_power * jump_multiplier
			
		if raycast.is_colliding() and Input.is_action_pressed(INPUT_MOVE_RIGHT):
			velocity.y = jump_power * jump_multiplier
			velocity.x = -wall_jump_pushback
			
		if raycast.is_colliding() and Input.is_action_pressed(INPUT_MOVE_LEFT):
			velocity.y = jump_power * jump_multiplier
			velocity.x = wall_jump_pushback
			
# Wall Slide
# the wall slide must be colliding with a wall and moving into it to be able to wall slide (without jumping)
func wall_slide(delta : float) -> void:
	if raycast.is_colliding() and !is_on_floor():
		if Input.is_action_just_pressed(INPUT_MOVE_LEFT) or Input.is_action_just_pressed(INPUT_MOVE_RIGHT):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false	

# Stops Dashing
func _on_dash_timer_timeout() -> void:
	dashing = false
	
# To Dash Again
func _on_dash_again_timeout() -> void:
	can_dash = true
	
# Coyote Timer
func _on_coyote_timer_timeout() -> void:
	coyote_jump = false
