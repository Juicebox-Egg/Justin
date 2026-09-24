extends Node

const NO_CHECKPOINT_POSITION := Vector2(-999, -999)
const MAIN_MENU_SCENE := "res://Assets/Scenes/main_menu.tscn"
const WORLD_0_SCENE := "res://Assets/Scenes/Worlds/world0.tscn"
const WORLD_1_SCENE := "res://Assets/Scenes/Worlds/world1.tscn"
const WORLD_2_SCENE := "res://Assets/Scenes/Worlds/world2.tscn"
const WORLD_3_SCENE := "res://Assets/Scenes/Worlds/world3.tscn"

func _load_level() -> void:
	GlobalScript.checkpoint_pos = NO_CHECKPOINT_POSITION
	GlobalScript.previous_checkpoint_node = null
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_texture_button_pressed() -> void:
	SceneTransition.change_scene_to_file(WORLD_0_SCENE)

func _on_texture_button_2_pressed() -> void:
	SceneTransition.change_scene_to_file(WORLD_1_SCENE)
	
func _on_world_2_pressed() -> void:
	SceneTransition.change_scene_to_file(WORLD_2_SCENE)

func _on_world_3_pressed() -> void:
	SceneTransition.change_scene_to_file(WORLD_3_SCENE)
	
