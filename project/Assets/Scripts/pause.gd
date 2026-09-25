extends Node

# References the pause menu panel so it can be shown or hidden.
@onready var pause_panel: Panel = %PausePanel

# Scene and input action used by the pause menu.
const MAIN_MENU_SCENE := "res://Assets/Scenes/main_menu.tscn"
const PAUSE := "pause"


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# Check whether the pause input has just been pressed.
	var esc_pressed = Input.is_action_just_pressed(PAUSE)

	if esc_pressed:
		# Pause the game and display the pause menu.
		get_tree().paused = true
		pause_panel.show()


func _on_resume_pressed() -> void:
	# Hide the pause menu and continue the game.
	pause_panel.hide()
	get_tree().paused = false


func _on_menu_pressed() -> void:
	# Unpause the game before returning to the main menu.
	get_tree().paused = false
	SceneTransition.change_scene_to_file(MAIN_MENU_SCENE)


func _on_exit_pressed() -> void:
	# Close the game when the exit button is pressed.
	get_tree().quit()
