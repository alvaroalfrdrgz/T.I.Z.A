extends Node3D

var main_current: bool = true
@onready var main_camera: Camera3D = $MainCamera
@onready var second_camera: Camera3D = $Professor/SecondCamera

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("third_person"):
		main_current = not main_current
	
	if main_current:
		main_camera.current = true
		second_camera.current = false
	else:
		main_camera.current = false
		second_camera.current = true
		GM.cam_position = "PROFESSOR"
