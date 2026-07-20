extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0

var speed_multiplier = 20.0
var jump_multiplier = -30.0
var direction = 0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# simple dash
const DASH_SPEED = 40.0
var dashing = false
var can_dash = true

# spikes
var took_damage = false
var can_move = true

# coyote jump
var coyote_jump: bool = false
var jumping: bool = false
var coyote_frames: int = 5
var was_on_floor: bool = false
@onready var coyote_timer = $CoyoteTimer

#wall jump
const wall_jump_pushback = 100

#checkpoint
@export var player_checkpont_pos: Vector2 = Vector2(-999, -999)

# coyote framerate
func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	add_to_group("player")
	
	if GlobalScript.checkpoint_pos != Vector2(-999, -999):
		global_position = GlobalScript.checkpoint_pos

func _input(event):
# Handle jump.
	if event.is_action_pressed("jump") and (is_on_floor() or coyote_jump):
		velocity.y = jump_power * jump_multiplier 
		jumping = true
	# Handle jump down platform
	if event.is_action_pressed("move_down") and is_on_floor():
		position.y += 1
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

# dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		velocity.y = 0.0
		$dash_timer.start()
		$dash_again.start()
		

# respawn
func respawn(respawn_pos:Vector2):
	self.visible = false
	can_move = false
	await get_tree().create_timer(0.5).timeout
	
	self.global_position = Vector2(respawn_pos)
	self.visible = true
	can_move = true
	await get_tree().create_timer(0.5).timeout
	
	took_damage = false


func _physics_process(delta: float) -> void:
# Add the gravity.
	if dashing:
		velocity.y = 0.0
		#print(velocity.y) was elif below
	elif not is_on_floor():
		velocity += get_gravity() * delta
	

# Spikes
	for i in get_slide_collision_count():
		var _collision = get_slide_collision(i)
		
		if _collision.get_collider().name == "Spikes": 
			if took_damage == false:
				took_damage = true
				respawn(player_checkpont_pos)

# Basic Movement
	if can_move == false:
		return
	else:
		direction = Input.get_axis("move_left", "move_right")
		if direction:
			if dashing:
				velocity.x = direction * speed * DASH_SPEED
			else:
				velocity.x = direction * speed * speed_multiplier
		else:
			velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
	
	move_and_slide()
	
# coyote jump
	if is_on_floor() and jumping:
		jumping = false
	if was_on_floor and !is_on_floor() and not jumping:
		coyote_jump = true
		coyote_timer.start()
	was_on_floor = is_on_floor()

# wall_jump?
func jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_power * jump_multiplier
		if is_on_wall() and Input.is_action_just_pressed("move_right"):
			velocity.y = jump_power * jump_multiplier
			velocity.x = -wall_jump_pushback
		if is_on_wall() and Input.is_action_just_pressed("move_left"):
			velocity.y = jump_power * jump_multiplier
			velocity.x = wall_jump_pushback

# stops dashing
func _on_dash_timer_timeout() -> void:
	dashing = false
# to dash again
func _on_dash_again_timeout() -> void:
	can_dash = true
# coyote timer
func _on_coyote_timer_timeout() -> void:
	coyote_jump = false
