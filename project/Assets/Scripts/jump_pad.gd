extends Node2D

# Name of the animation played when the jump pad is activated.
const ACTIVATE_ANIMATION := "activate"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only launch the player when the player enters the jump pad.
	if body is PlayerController:
		# Set the player's vertical velocity to launch them upwards.
		body.velocity.y = body.JUMP_PAD_HEIGHT
		# Play the activation animation to provide visual feedback.
		$Sprite2D/AnimationPlayer.play(ACTIVATE_ANIMATION)
