extends CanvasLayer

const TRANSITION_ANIMATION := "disolve"

func change_scene_to_file(target: String) -> void:
	$AnimationPlayer.play(TRANSITION_ANIMATION)
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards(TRANSITION_ANIMATION)
