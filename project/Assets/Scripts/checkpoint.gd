extends Sprite2D

# Group name used to identify the player when entering the checkpoint.
const PLAYER_GROUP := "player"

# Sprite frames used to show whether the checkpoint is active or inactive.
const ACTIVE_FRAME := 1
const INACTIVE_FRAME := 0

# Set the correct checkpoint appearance when the scene starts.
func _ready() -> void:
	_update_sprite()


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only activate the checkpoint if the player enters its area.
	if body.is_in_group(PLAYER_GROUP):

		# Store this checkpoint's position as the player's new respawn point.
		GlobalScript.checkpoint_position = $Marker2D.global_position
		body.player_checkpoint_position = $Marker2D.global_position

		# Remember this checkpoint as the currently active one.
		if GlobalScript.previous_checkpoint_node:
			GlobalScript.previous_checkpoint_node._update_sprite()

		# Update this checkpoint's sprite to show that it is active.
		GlobalScript.previous_checkpoint_node = self
		_update_sprite()


# Compare this checkpoint's position with the saved respawn position.
func _update_sprite() -> void:
	if $Marker2D.global_position == GlobalScript.checkpoint_position:
		# Use the active frame when this is the current checkpoint.
		frame = ACTIVE_FRAME
	else:
		# Use the inactive frame when this is not the current checkpoint.
		frame = INACTIVE_FRAME
