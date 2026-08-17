extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite = Sprite2D
@export var raycast : Node

func _process(delta):
	# flips player sprite
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
		
	# flip raycast walljump
	if not player_controller.direction == raycast.get_parent().scale.x:
		raycast.get_parent().scale.x = player_controller.direction
	
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
		
	# plays dash anim
	if player_controller and Input.is_action_just_pressed("dash"):
		animation_player.play("dash_anim")
