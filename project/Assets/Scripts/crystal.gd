extends Node2D

const END_SCENE := "res://Assets/Scenes/end.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		SceneTransition.change_scene_to_file(END_SCENE)
