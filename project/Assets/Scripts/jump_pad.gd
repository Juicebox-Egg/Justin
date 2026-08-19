extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("jump_pad_height"):
		body.velocity.y = body.jump_pad_height
		$Sprite2D/AnimationPlayer.play("activate")
