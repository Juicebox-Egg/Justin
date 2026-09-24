extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite = Sprite2D
@export var raycast : RayCast2D
@export var player_animator : Node

var is_dashing = false
var is_dying = false

const DIRECTION_RIGHT := 1
const DIRECTION_LEFT := -1
const VELOCITY_ZERO := 0.0

# ANIM short for Animation
const ANIM_DASH := "dash_anim"
const ANIM_DEATH := "death_anim"
const ANIM_MOVE := "move"
const ANIM_IDLE := "idle"
const ANIM_JUMP := "jump_anim"
const ANIM_FALL := "fall"

const INPUT_DASH := "dash"

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	
	# death animation
func play_death():
	is_dying = true
	is_dashing = false
	animation_player.play(ANIM_DEATH)
	
func _on_animation_finished(anim_name):
	if anim_name == ANIM_DASH:
		is_dashing = false
	if anim_name == ANIM_DEATH:
		is_dying = false
		
	# resets death anim
func reset_after_death():
	is_dying = false
	is_dashing = false
	
	if abs(player_controller.velocity.x) > VELOCITY_ZERO:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)

func _process(delta):
	# flips player sprite
	if player_controller.direction == DIRECTION_RIGHT:
		sprite.flip_h = false
	elif player_controller.direction == DIRECTION_LEFT:
		sprite.flip_h = true
		
	# flip raycast walljump
	if not player_controller.direction == raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction
	
	# dash anim
	if Input.is_action_just_pressed(INPUT_DASH) and not is_dying:
		is_dashing = true
		animation_player.play(ANIM_DASH)
		return
		
	# Don't let other animations interrupt dash
	if is_dashing:
		return
		
	# Don't override death animation
	if is_dying:
		return
	
	# plays movement anim
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play(ANIM_MOVE)
	else:
		animation_player.play(ANIM_IDLE)

	# plays jump anim
	if player_controller.velocity.y < 0.0:
		animation_player.play(ANIM_JUMP)
	elif player_controller.velocity.y > 0.0:
		animation_player.play(ANIM_FALL)
