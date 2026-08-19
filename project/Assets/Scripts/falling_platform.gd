extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

@export var reset_time: float = 1.0
@export var shake_time: float = 0.5
@export var fall_time: float = 0.2

var is_triggered = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var reset_position = global_position

var original_collision_layer
var original_collision_mask

func _ready():
	set_physics_process(false)
	# remember the original collision settings
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

func collide_with():
	if is_triggered:
		return
	is_triggered = true
	velocity = Vector2.ZERO
	animation_player.play("shake")
	await get_tree().create_timer(shake_time).timeout

	if not is_triggered:
		return
	# Start falling
	set_physics_process(true)
	# Let it fall for 0.3 seconds
	await get_tree().create_timer(fall_time).timeout

	# Stop and hide the platform
	set_physics_process(false)
	velocity = Vector2.ZERO
	visible = false
	# disable collision
	collision_layer = 0
	collision_mask = 0
	await get_tree().create_timer(reset_time).timeout

	global_position = reset_position
	# restores collision
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	# reappear
	visible = true
	is_triggered = false
