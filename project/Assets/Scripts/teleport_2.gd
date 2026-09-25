extends Node2D

# Stores the scene path for World 2.
const WORLD_2_SCENE := "res://Assets/Scenes/Worlds/world2.tscn"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only transition to World 2 when the player enters the area.
	if body is PlayerController:
		SceneTransition.change_scene_to_file(WORLD_2_SCENE)
