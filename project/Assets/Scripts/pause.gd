extends Node

@onready var pause_panel: Panel = %PausePanel

const MAIN_MENU_SCENE := "res://Assets/Scenes/main_menu.tscn"
const PAUSE := "pause"

func _ready():
	pass
	
func _process(delta):
	var esc_pressed = Input.is_action_just_pressed(PAUSE)
	if (esc_pressed == true):
		get_tree().paused = true
		pause_panel.show()

func _on_resume_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false

func _on_menu_pressed() -> void:
	get_tree().paused = false
	SceneTransition.change_scene_to_file(MAIN_MENU_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()
