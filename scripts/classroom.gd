extends Node3D

var main_current: bool = true
@onready var main_camera: Camera3D = $MainCamera
@onready var cam_table_1: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable1
@onready var cam_table_2: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable2
@onready var cam_table_3: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable3
@onready var cam_table_4: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable4
@onready var cam_table_5: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable5
@onready var cam_table_6: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable6
@onready var cam_table_7: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable7
@onready var cam_table_8: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable8
@onready var cam_table_9: Camera3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras/CamTable9

@onready var cameras: Node3D = $UI/CeckWindows/StudentCamera/CameraViewport/Cameras
@onready var hiden_cameras: Node3D = $UI/CeckWindows/StudentCamera/HidenCameras

func _process(_delta: float) -> void:
	main_camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cam1"):
		turn_off_all_cameras()
		cam_table_1.reparent(cameras)
	if event.is_action_pressed("cam2"):
		turn_off_all_cameras()
		cam_table_2.reparent(cameras)
	if event.is_action_pressed("cam3"):
		turn_off_all_cameras()
		cam_table_3.reparent(cameras)
	if event.is_action_pressed("cam4"):
		turn_off_all_cameras()
		cam_table_4.reparent(cameras)
	if event.is_action_pressed("cam5"):
		turn_off_all_cameras()
		cam_table_5.reparent(cameras)
	if event.is_action_pressed("cam6"):
		turn_off_all_cameras()
		cam_table_6.reparent(cameras)
	if event.is_action_pressed("cam7"):
		turn_off_all_cameras()
		cam_table_7.reparent(cameras)
	if event.is_action_pressed("cam8"):
		turn_off_all_cameras()
		cam_table_8.reparent(cameras)
	if event.is_action_pressed("cam9"):
		turn_off_all_cameras()
		cam_table_9.reparent(cameras)

func turn_off_all_cameras():
	cam_table_1.reparent(hiden_cameras)
	cam_table_2.reparent(hiden_cameras)
	cam_table_3.reparent(hiden_cameras)
	cam_table_4.reparent(hiden_cameras)
	cam_table_5.reparent(hiden_cameras)
	cam_table_6.reparent(hiden_cameras)
	cam_table_7.reparent(hiden_cameras)
	cam_table_8.reparent(hiden_cameras)
	cam_table_9.reparent(hiden_cameras)
