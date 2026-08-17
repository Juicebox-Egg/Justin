extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("first work")
	if body is PlayerController:
		print("second work")
		get_tree().change_scene_to_file("res://Assets/Scenes/Worlds/word1.tscn")
