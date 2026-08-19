extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite = Sprite2D
@export var raycast : Node



@warning_ignore("unused_parameter")
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
	if Input.is_action_just_pressed("dash"):
		animation_player.play("Dash")
		await animation_player.animation_finished
		
	# plays death anim
	#if player_controller.took_damage = true:
		#animation_player.play("fall")
