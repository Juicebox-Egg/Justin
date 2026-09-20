extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		SceneTransition.change_scene_to_file("res://Assets/Scenes/end.tscn")
