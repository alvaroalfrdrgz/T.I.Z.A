extends StaticBody3D

const COLORS: Array[Color] = [Color.ORANGE_RED, Color.ROYAL_BLUE, Color.LIME_GREEN]

@onready var screen: MeshInstance3D = $Screen
@onready var screen_light: OmniLight3D = $ScreenLight
@onready var color_timer: Timer = $ColorTimer
@export var min_time: float = 5.5
@export var max_time: float = 10.5

func _ready() -> void:
	color_timer.timeout.connect(change_screen_color)
	await get_tree().create_timer(6).timeout
	create_tween().tween_property(screen.material_overlay, "albedo_color", Color.BLUE, 3)
	create_tween().tween_property(screen_light, "light_color", Color.BLUE, 3)
	await get_tree().create_timer(6).timeout 
	change_screen_color()
	set_random_timer()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("change"):
		change_screen_color()
	
func change_screen_color():
	var material = screen.material_overlay
	var color_number: int = randi_range(0, COLORS.size() - 1)
	material.albedo_color = COLORS[color_number]
	screen_light.light_color = COLORS[color_number]
	set_random_timer()
	
func set_random_timer():
	var new_wait_time: float = randf_range(min_time, max_time)
	color_timer.wait_time = new_wait_time
	color_timer.start()
