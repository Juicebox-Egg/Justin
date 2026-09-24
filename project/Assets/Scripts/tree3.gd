extends Sprite2D

const SHADER_PARAMETER := "Random_Strength"
const MIN := -5.0
const MAX := 5.0

func _ready() -> void:
	set_instance_shader_parameter(SHADER_PARAMETER, randf_range(MIN, MAX))
