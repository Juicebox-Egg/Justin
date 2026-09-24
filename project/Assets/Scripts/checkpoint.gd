extends Sprite2D

const PLAYER_GROUP := "player"
const ACTIVE_FRAME := 1
const INACTIVE_FRAME := 0

func _ready() -> void:
	_update_sprite()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(PLAYER_GROUP):
		GlobalScript.checkpoint_pos = $Marker2D.global_position
		body.player_checkpont_pos = $Marker2D.global_position
		if GlobalScript.previous_checkpoint_node:
			GlobalScript.previous_checkpoint_node._update_sprite()
		GlobalScript.previous_checkpoint_node = self
		_update_sprite()

func _update_sprite() -> void:
	if $Marker2D.global_position == GlobalScript.checkpoint_pos:
		frame = ACTIVE_FRAME
	else:
		frame = INACTIVE_FRAME
