extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		get_tree().change_scene_to_file("res://Assets/Scenes/Worlds/world1.tscn")
