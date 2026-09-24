extends Path2D
class_name MovingPlatform

@export var path_time = 1.0
@export var looping = false
@export var easeing : Tween.EaseType
@export var transition : Tween.TransitionType
@export var path_follow_2D : PathFollow2D

const PATH_START := 0.0
const PATH_END := 1.0
const NO_DURATION := 0.0

func _ready():
	move_tween()
	
func move_tween():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(path_follow_2D, "progress_ratio", PATH_END, path_time).set_ease(easeing).set_trans(transition)
	if looping:
		tween.tween_property(path_follow_2D, "progress_ratio", PATH_START, path_time).set_ease(easeing).set_trans(transition)
	else: 
		tween.tween_property(path_follow_2D, "progress_ratio", PATH_START, NO_DURATION).set_ease(easeing).set_trans(transition)
