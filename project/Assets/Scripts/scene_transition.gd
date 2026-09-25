extends CanvasLayer

# Name of the animation used for the scene transition effect.
const TRANSITION_ANIMATION := "disolve"


func change_scene_to_file(target: String) -> void:
	# Play the transition animation to hide the current scene.
	$AnimationPlayer.play(TRANSITION_ANIMATION)
	# Wait until the transition finishes before changing scenes.
	await $AnimationPlayer.animation_finished
	# Load the requested scene once the screen is covered by the transition.
	get_tree().change_scene_to_file(target)
	# Reverse the animation to reveal the new scene.
	$AnimationPlayer.play_backwards(TRANSITION_ANIMATION)
