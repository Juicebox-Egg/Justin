extends Node2D

const WORLD_2_SCENE := "res://Assets/Scenes/Worlds/world2.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		SceneTransition.change_scene_to_file(WORLD_2_SCENE)
