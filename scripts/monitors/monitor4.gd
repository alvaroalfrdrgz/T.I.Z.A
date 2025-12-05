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

var record: Dictionary = {
	"ai_times" : 0,
	"code_times" : 0,
	"video_times" : 0,
}

var ai_detected_times: int = 0

@onready var black_screen: TextureRect = $ScreenViewport/BlackScreen
@onready var video_intro: VideoStreamPlayer = $ScreenViewport/VideoIntro

var detected: bool = false
var pc_number: String = "4"
@onready var screen_light: OmniLight3D = $ScreenLight
@onready var color_timer: Timer = $ColorTimer
@export var min_time: float = 5.5
@export var max_time: float = 10.5

var active_screen: int = 0
var color_number: int = 0

var already_failure: bool = false

func _ready() -> void:
	
	screen_off()
	
	await get_tree().create_timer(2).timeout
	video_intro.play()
	black_screen.visible = false
	
	color_timer.timeout.connect(change_screen_texture)
	
	create_tween().tween_property(screen_light, "light_color", Color.DARK_RED, 5)
	await get_tree().create_timer(8).timeout
	video_intro.stop()
	
	code_screen_active()
	await get_tree().create_timer(7).timeout
	
	change_screen_texture()
	set_random_timer()

func _process(_delta: float) -> void:
	if GM.game_ended:
		if already_failure:
			if record["ai_times"] > 0 and record["ai_times"] <= 2:
				GM.reputation += 2
			elif record["ai_times"] > 2:
				GM.reputation += 4
		else:
			if record["ai_times"] > 0 and record["ai_times"] <= 2:
				GM.reputation -= 2
			elif record["ai_times"] > 2:
				GM.reputation -= 4

func change_screen_texture():
	var screen_number: int = randi_range(0, 9)
	match screen_number:
		0: ai_screen_active()
		1: code_screen_active()
		2: video_screen_active()
		3: code_screen_active()
		4: code_screen_active()
		5: video_screen_active()
		6: code_screen_active()
		7: code_screen_active()
		8: code_screen_active()
		9: ai_screen_active()
		
	screen_light.light_color = COLORS[color_number]
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
		if active_screen == 2:
			ai_detected_times += 1
		GM.in_revision_area = true
		GM.active_camera = "cam" + pc_number
func _on_revision_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("professor"):
		if GM.student4_strikes >= 3:
			color_timer.stop()
			wallpaper_screen_active()
			if already_failure == false:
				GM.text_active = true
				GM.text = "El estudiante Dariel ha suspendido el examen"
				already_failure = true
		GM.in_revision_area = false

#region screen functions
func code_screen_active():
	SCREENS[0].visible = false
	SCREENS[1].visible = true
	SCREENS[2].visible = false
	SCREENS[3].visible = false
	black_screen.visible = false
	screen_light.light_color = COLORS[0]
	active_screen = 1 #Code Editor
	color_number = 1
	record["code_times"] += 1
	min_time = 5.5
	max_time = 10.5
func ai_screen_active():
	SCREENS[0].visible = true
	SCREENS[1].visible = false
	SCREENS[2].visible = false
	SCREENS[3].visible = false
	black_screen.visible = false
	screen_light.light_color = COLORS[1]
	active_screen = 2 #Artificial Intelligence
	color_number = 0
	record["ai_times"] += 1
	min_time = 2.5
	max_time = 7.5
func video_screen_active():
	SCREENS[0].visible = false
	SCREENS[1].visible = false
	SCREENS[2].visible = true
	SCREENS[3].visible = false
	black_screen.visible = false
	screen_light.light_color = COLORS[2]
	active_screen = 3 #Online Videos
	color_number = 2
	record["video_times"] += 1
	min_time = 4.5
	max_time = 9.0
	
func wallpaper_screen_active():
	SCREENS[0].visible = false
	SCREENS[1].visible = false
	SCREENS[2].visible = false
	SCREENS[3].visible = true
	black_screen.visible = false
	active_screen = 4 #Wallpaper
func screen_off():
	SCREENS[0].visible = false
	SCREENS[1].visible = false
	SCREENS[2].visible = false
	SCREENS[3].visible = false
	black_screen.visible = true
	active_screen = 4 #Screen Off
#endregion
