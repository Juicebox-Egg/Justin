extends Node

# Default position used to indicate that no checkpoint is active.
const NO_CHECKPOINT_POSITION := Vector2(-999, -999)

# Stores the scene paths used by the menu buttons.
const MAIN_MENU_SCENE := "res://Assets/Scenes/main_menu.tscn"
const WORLD_0_SCENE := "res://Assets/Scenes/Worlds/world0.tscn"
const WORLD_1_SCENE := "res://Assets/Scenes/Worlds/world1.tscn"
const WORLD_2_SCENE := "res://Assets/Scenes/Worlds/world2.tscn"
const WORLD_3_SCENE := "res://Assets/Scenes/Worlds/world3.tscn"


func _load_level() -> void:
	# Reset checkpoint data so the new game starts without an active checkpoint.
	GlobalScript.checkpoint_position = NO_CHECKPOINT_POSITION
	GlobalScript.previous_checkpoint_node = null
	# Return the player to the main menu.
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _on_exit_pressed() -> void:
	# Close the game when the exit button is pressed.
	get_tree().quit()


func _on_texture_button_pressed() -> void:
	# Load World 0 when its level button is selected.
	SceneTransition.change_scene_to_file(WORLD_0_SCENE)


func _on_texture_button_2_pressed() -> void:
	# Load World 1 when its level button is selected.
	SceneTransition.change_scene_to_file(WORLD_1_SCENE)


func _on_world_2_pressed() -> void:
	# Load World 2 when its level button is selected.
	SceneTransition.change_scene_to_file(WORLD_2_SCENE)


func _on_world_3_pressed() -> void:
	# Load World 3 when its level button is selected.
	SceneTransition.change_scene_to_file(WORLD_3_SCENE)
