extends Node


func _on_world_0_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Worlds/word0.tscn")

func _on_world_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Worlds/word1.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
