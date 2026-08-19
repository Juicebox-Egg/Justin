extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite = Sprite2D
@export var raycast : RayCast2D
@export var player_animator : Node

var is_dashing = false
var is_dying = false

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	
	# death animation
func play_death():
	is_dying = true
	is_dashing = false
	animation_player.play("death_anim")
	
func _on_animation_finished(anim_name):
	if anim_name == "dash_anim":
		is_dashing = false
	if anim_name == "death_anim":
		is_dying = false
		
	# resets death anim
func reset_after_death():
	is_dying = false
	is_dashing = false
	
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("idle")

func _process(delta):
	# flips player sprite
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
		
	# flip raycast walljump
	if not player_controller.direction == raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction
	
	# dash anim
	if Input.is_action_just_pressed("dash") and not is_dying:
		is_dashing = true
		animation_player.play("dash_anim")
		return
		
	# Don't let other animations interrupt dash
	if is_dashing:
		return
		
	# Don't override death animation
	if is_dying:
		return
	
	# plays movement anim
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("idle")
	# plays jump anim
	if player_controller.velocity.y < 0.0:
		animation_player.play("jump_anim")
	elif player_controller.velocity.y > 0.0:
		animation_player.play("fall")
