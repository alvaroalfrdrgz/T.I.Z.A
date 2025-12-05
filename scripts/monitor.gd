class_name Monitor
extends StaticBody3D

@export var COLORS: Array[Color] = [
	Color.ROYAL_BLUE,
	Color.LIME_GREEN,
	Color.ORANGE_RED
]

@onready var SCREENS: Array[TextureRect] = [
	$ScreenViewport/ArtificialIntelligence,
	$ScreenViewport/CodeEditor,
	$ScreenViewport/OnlineVideos,
	$ScreenViewport/Wallpaper,
]

@onready var black_screen: TextureRect = $ScreenViewport/BlackScreen
@onready var video_intro: VideoStreamPlayer = $ScreenViewport/VideoIntro

var detected: bool = false
var pc_number: String = ""
@onready var screen_light: OmniLight3D = $ScreenLight
@onready var color_timer: Timer = $ColorTimer
@export var min_time: float = 5.5
@export var max_time: float = 10.5

var active_screen = 0

func _ready() -> void:
	#Al comenzar no se muestra nada en la pantalla:
	SCREENS[0].visible = false
	SCREENS[1].visible = false
	SCREENS[2].visible = false
	SCREENS[3].visible = false
	black_screen.visible = true
	
	#Se muestra la intro del SO y posteriormente
	#cambia a alguna de las otras pantallas
	await get_tree().create_timer(2).timeout
	black_screen.visible = false
	video_intro.play()
	color_timer.timeout.connect(change_screen_texture)
	create_tween().tween_property(screen_light, "light_color", Color.DARK_RED, 5)
	await get_tree().create_timer(8).timeout
	video_intro.stop()
	change_screen_texture()
	set_random_timer()

func _process(_delta: float) -> void:
	if active_screen == 1:
		pass
	elif active_screen == 2:
		pass
	else:
		pass

func change_screen_texture():
	var screen_number: int = randi_range(0, 2)
	
	match screen_number:
		0:
			SCREENS[0].visible = true
			SCREENS[1].visible = false
			SCREENS[2].visible = false
			SCREENS[3].visible = false
			active_screen = 1 #Artificial Intelligence
		1:
			SCREENS[0].visible = false
			SCREENS[1].visible = true
			SCREENS[2].visible = false
			SCREENS[3].visible = false
			active_screen = 2 #Code Editor
		2:
			SCREENS[0].visible = false
			SCREENS[1].visible = false
			SCREENS[2].visible = true
			SCREENS[3].visible = false
			active_screen = 3 #Online Videos
	
	screen_light.light_color = COLORS[screen_number]
	set_random_timer()
	
func set_random_timer():
	var new_wait_time: float = randf_range(min_time, max_time)
	color_timer.wait_time = new_wait_time
	color_timer.start()

func _on_area_near_body_entered(body: Node3D) -> void:
	if body.is_in_group("professor"):
		GM.in_near_area = true
func _on_area_near_body_exited(body: Node3D) -> void:
	if body.is_in_group("professor"):
		GM.in_near_area = false
func _on_revision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("professor"):
		GM.in_revision_area = true
		GM.active_camera = "cam" + pc_number
func _on_revision_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("professor"):
		GM.in_revision_area = false
