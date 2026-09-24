extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite = Sprite2D
@export var raycast : Node

const DIRECTION_RIGHT := 1
const DIRECTION_LEFT := -1
const VELOCITY_ZERO := 0.0

# ANIM short for Animation
const ANIM_MOVE := "move"
const ANIM_IDLE := "idle"
const ANIM_JUMP := "jump_anim"
const ANIM_FALL := "fall"
const ANIM_DASH := "Dash"

const INPUT_DASH := "dash"

@warning_ignore("unused_parameter")
func _process(delta):
	# flips player sprite
	if player_controller.direction == DIRECTION_RIGHT:
		sprite.flip_h = false
	elif player_controller.direction == DIRECTION_LEFT:
		sprite.flip_h = true
		
	# flip raycast walljump
	if not player_controller.direction == raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction
	
	# plays movement anim
	if abs(player_controller.velocity.x) > VELOCITY_ZERO:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)
	# plays jump anim
	if player_controller.velocity.y < VELOCITY_ZERO:
		animation_player.play(ANIM_JUMP)
	elif player_controller.velocity.y > VELOCITY_ZERO:
		animation_player.play(ANIM_FALL)
		
	# plays dash anim
	if Input.is_action_just_pressed(INPUT_DASH):
		animation_player.play(ANIM_DASH)
		await animation_player.animation_finished
		
