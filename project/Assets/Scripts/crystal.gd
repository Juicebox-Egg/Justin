extends Node2D

# Stores the path to the end scene so it can be loaded when reached.
const END_SCENE := "res://Assets/Scenes/end.tscn"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Only transition to the end scene when the player enters the area.
	if body is PlayerController:
		SceneTransition.change_scene_to_file(END_SCENE)
