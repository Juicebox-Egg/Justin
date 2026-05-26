extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0

#simple dash
const DASH_SPEED = 50.0
var dashing = false
var can_dash = true

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
		$dash_timer.start()
		$dash_again.start()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
