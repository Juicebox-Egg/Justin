extends Sprite2D

# Name of the shader parameter that controls the random effect strength.
const SHADER_PARAMETER := "Random_Strength"

# Minimum and maximum values used for the random shader strength.
const MIN := -5.0
const MAX := 5.0


func _ready() -> void:
	# Give this sprite a random shader strength when the scene starts.
	set_instance_shader_parameter(SHADER_PARAMETER, randf_range(MIN, MAX))
