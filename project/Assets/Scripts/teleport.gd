extends Sprite2D

# Stores the scene path for World 1.
const WORLD_1_SCENE := "res://Assets/Scenes/Worlds/world1.tscn"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only transition to World 1 when the player enters the area.
	if body is PlayerController:
		SceneTransition.change_scene_to_file(WORLD_1_SCENE)
