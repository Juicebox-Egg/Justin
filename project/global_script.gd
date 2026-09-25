extends Node

# Position used to indicate that no checkpoint has been activated yet.
const NO_CHECKPOINT_POSITION := Vector2(-999, -999)

# Stores the position where the player should respawn.
var checkpoint_position: Vector2 = NO_CHECKPOINT_POSITION
# Stores the previous checkpoint so its sprite can be changed when a new one is activated.
var previous_checkpoint_node: Sprite2D = null
