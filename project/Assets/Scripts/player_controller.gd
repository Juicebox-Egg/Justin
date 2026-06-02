extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#simple dash
const DASH_SPEED = 50.0
var dashing = false
var can_dash = true

#spikes
var took_damage = false
var can_move = true

func _input(event):
	# Handle jump.
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier 
	# Handle jump down platform
	if event.is_action_pressed("move_down") and is_on_floor():
		position.y += 1
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

#dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		velocity.y = 0.0
		$dash_timer.start()
		$dash_again.start()
		

#respawn
func respawn():
	self.visible = false
	can_move = false
	await get_tree().create_timer(0.5).timeout
	
	self.global_position = Vector2(-258, -45)
	self.visible = true
	can_move = true
	await get_tree().create_timer(0.5).timeout
	
	took_damage = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if dashing:
		print(velocity.y)
	elif not is_on_floor():
		velocity += get_gravity() * delta

	#Collision Checking eg: if touching spike
	for i in get_slide_collision_count():
		var _collision = get_slide_collision(i)
		
		if _collision.get_collider().name == "Spikes": #if player touches tilemap
			if took_damage == false:
				took_damage = true
				respawn()


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

#stops dashing
func _on_dash_timer_timeout() -> void:
	dashing = false
#to dash again
func _on_dash_again_timeout() -> void:
	can_dash = true
