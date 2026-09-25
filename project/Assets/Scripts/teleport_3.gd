extends Node2D

# Stores the scene path for World 3.
const WORLD_3_SCENE := "res://Assets/Scenes/Worlds/world3.tscn"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only transition to World 3 when the player enters the area.
	if body is PlayerController:
		SceneTransition.change_scene_to_file(WORLD_3_SCENE)
