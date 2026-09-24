extends Node2D

const JUMP_HEIGHT := "jump_pad_height"
const ACTIVATE_ANIMATION := "activate"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if JUMP_HEIGHT in body:
		body.velocity.y = body.jump_pad_height
		$Sprite2D/AnimationPlayer.play(ACTIVATE_ANIMATION)
