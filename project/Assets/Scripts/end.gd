extends Node


func _on_exit_pressed() -> void:
	# Close the game when the exit button is pressed.
	get_tree().quit()
