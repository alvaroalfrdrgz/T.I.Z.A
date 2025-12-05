extends Node3D

var main_current: bool = true
@onready var cameras: Array[Camera3D] = [
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable1,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable2,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable3,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable4,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable5,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable6,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable7,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable8,
	$UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable9,
]
@onready var main_camera: Camera3D = $MainCamera
@onready var sun_animation: AnimationPlayer = $WindowSun/AnimationPlayer

@onready var clock: Sprite3D = $Walls/MainWall/Clock
@onready var time_animation: AnimationPlayer = $Walls/MainWall/Clock/TimeAnimation
@onready var end_ui: CanvasLayer = $EndUI

func _ready() -> void:
	sun_animation.play_backwards("sun_move")

func _process(_delta: float) -> void:
	main_camera.current = true
	if GM.active_camera == "cam1":
		turn_off_all_cameras()
		cameras[0].current = true
	if GM.active_camera == "cam2":
		turn_off_all_cameras()
		cameras[1].current = true
	if GM.active_camera == "cam3":
		turn_off_all_cameras()
		cameras[2].current = true
	if GM.active_camera == "cam4":
		turn_off_all_cameras()
		cameras[3].current = true
	if GM.active_camera == "cam5":
		turn_off_all_cameras()
		cameras[4].current = true
	if GM.active_camera == "cam6":
		turn_off_all_cameras()
		cameras[5].current = true
	if GM.active_camera == "cam7":
		turn_off_all_cameras()
		cameras[6].current = true
	if GM.active_camera == "cam8":
		turn_off_all_cameras()
		cameras[7].current = true
	if GM.active_camera == "cam9":
		turn_off_all_cameras()
		cameras[8].current = true

	await time_animation.animation_finished
	GM.game_ended = true
	end_ui.visible = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_DISABLED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	if event.is_action_pressed("ui_accept"):
		end_ui.visible = true
		get_tree().paused = true

func turn_off_all_cameras():
	cameras[0].current = false
	cameras[1].current = false
	cameras[2].current = false
	cameras[3].current = false
	cameras[4].current = false
	cameras[5].current = false
	cameras[6].current = false
	cameras[7].current = false
	cameras[8].current = false
	
