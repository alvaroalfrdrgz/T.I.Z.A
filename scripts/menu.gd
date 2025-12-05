extends CanvasLayer

@onready var menu: CanvasLayer = $"."
@onready var main_buttons: Panel = $MainButtons
@onready var options: Panel = $Options
@onready var main_draw: TextureRect = $MainButtons/MainDraw
@onready var main_buttons_anim: AnimationPlayer = $MainButtons/MainButtonsAnim
@onready var options_anim: AnimationPlayer = $Options/OptionsAnim
@onready var transition: TextureRect = $Transition
@onready var transition_anim: AnimationPlayer = $Transition/AnimationPlayer

#region buttons
@onready var play: Button = $MainButtons/Play
@onready var settings: Button = $MainButtons/VBoxContainer/Settings
@onready var exit: Button = $MainButtons/Exit
@onready var back: Button = $Options/Back
#endregion

var can_press: bool = true

func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	transition.visible = false
	
func _on_play_button_down() -> void:
	GM.time_start = 1
	SG.game_started = true
	menu.visible = false

func _process(_delta: float) -> void:
	if GM.reputation <= 10:
		main_draw.texture = preload("uid://c1ahxw3tr30le")
	elif GM.reputation <= 30:
		main_draw.texture = preload("uid://4cu87xbb1e8v")
	elif GM.reputation <= 60:
		main_draw.texture = preload("uid://bnmwthwugidm6")
	elif GM.reputation <= 90:
		main_draw.texture = preload("uid://cwtumbonnismu")
	elif GM.reputation > 90:
		main_draw.texture = preload("uid://ctn48337byl50")
		
func _on_play_pressed() -> void:
	if can_press:
		transition.visible = true
		transition_anim.play("transition")
		await transition_anim.animation_finished
		get_tree().change_scene_to_file("res://scenes/classroom1.tscn")
	
func _on_settings_pressed() -> void:
	if can_press:
		main_buttons_anim.play("disappear")
		can_press = false
		await main_buttons_anim.animation_finished
		can_press = true
		options_anim.play("appear")

func _on_exit_pressed() -> void:
	if can_press:
		get_tree().quit()

func _on_back_pressed() -> void:
	options_anim.play("disappear")
	can_press = false
	await options_anim.animation_finished
	can_press = true
	main_buttons_anim.play("appear")
	
@onready var hovered_play: AnimatedSprite2D = $MainButtons/VBoxContainer/HoveredPlay
@onready var hovered_settings: AnimatedSprite2D = $MainButtons/VBoxContainer/HoveredSettings
@onready var hovered_exit: AnimatedSprite2D = $MainButtons/VBoxContainer/HoveredExit
@onready var hovered_back: AnimatedSprite2D = $Options/HoveredBack
func _on_play_mouse_entered() -> void:
	hovered_play.play("default")
func _on_play_mouse_exited() -> void:
	hovered_play.play_backwards("default")
func _on_settings_mouse_entered() -> void:
	hovered_settings.play("default")
func _on_settings_mouse_exited() -> void:
	hovered_settings.play_backwards("default")
func _on_exit_mouse_entered() -> void:
	hovered_exit.play("default")
func _on_exit_mouse_exited() -> void:
	hovered_exit.play_backwards("default")
func _on_back_mouse_entered() -> void:
	hovered_back.play("default")
func _on_back_mouse_exited() -> void:
	hovered_back.play_backwards("default")
