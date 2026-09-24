extends Node2D

const WORLD_3_SCENE := "res://Assets/Scenes/Worlds/world3.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		SceneTransition.change_scene_to_file(WORLD_3_SCENE)
