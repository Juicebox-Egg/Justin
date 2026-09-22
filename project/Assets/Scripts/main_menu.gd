extends Node

func _load_level() -> void:
	GlobalScript.checkpoint_pos = Vector2(-999, -999)
	GlobalScript.previous_checkpoint_node = null
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
	

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_texture_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://Assets/Scenes/Worlds/world0.tscn")

func _on_texture_button_2_pressed() -> void:
	SceneTransition.change_scene_to_file("res://Assets/Scenes/Worlds/world1.tscn")
	
func _on_world_2_pressed() -> void:
	SceneTransition.change_scene_to_file("res://Assets/Scenes/Worlds/world2.tscn")

func _on_world_3_pressed() -> void:
	SceneTransition.change_scene_to_file("res://Assets/Scenes/Worlds/world3.tscn")
