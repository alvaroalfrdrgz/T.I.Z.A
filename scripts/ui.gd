class_name UI
extends CanvasLayer

@onready var professor_name: Label = $ProfessorStats/ProfessorName
@onready var cintra_amount: Label = $ProfessorStats/CintraAmount
@onready var cintra_bar: TextureProgressBar = $ProfessorStats/CintraBar
@onready var professor_picture: TextureRect = $ProfessorStats/ProfessorPicture
@onready var cintra_picture: TextureRect = $ProfessorStats/CintraPicture
@onready var stamina_bar: TextureProgressBar = $ProfessorStats/StaminaBar
@onready var stamina_text: Label = $ProfessorStats/StaminaText
@onready var professor: CharacterBody3D = %Professor
var is_denied_effect_active: bool = false
@onready var student_name: Label = $StudentStats/StudentName
@onready var ui: UI = $"."

@onready var ceck_windows: Panel = $CeckWindows
@onready var check_windows_animation: AnimationPlayer = $CeckWindows/CheckWindowsAnimation
@onready var exit_button: Button = $CeckWindows/ExitButton

func _ready() -> void:
	check_windows_animation.play("INIT")
	
	ui.visible = false
	await get_tree().create_timer(1.15).timeout
	ui.visible = true

func _process(_delta: float) -> void:
	cintra_amount.text = "X" + str(GM.cintra)
	stamina_bar.value = professor.stamina
	cintra_bar.value = professor.remaining_cintra_time
	
	if professor.stamina < 20:
		create_tween().tween_property(stamina_bar, "tint_progress", Color(18.892, 0.0, 0.0, 1.0),0.1)
	else:
		create_tween().tween_property(stamina_bar, "tint_progress", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	
	if Input.is_action_just_released("item"):
		if GM.cintra <= 0:
			play_denied_effect()

func play_denied_effect():
	if is_denied_effect_active:
		return
	
	is_denied_effect_active = true
	var original_pos = cintra_bar.position
	var tween = create_tween()
	tween.tween_property(cintra_bar, "position:x", original_pos.x + 4, 0.03)
	tween.tween_property(cintra_bar, "position:x", original_pos.x - 4, 0.03)
	tween.tween_property(cintra_bar, "position:x", original_pos.x + 4, 0.03)
	tween.tween_property(cintra_bar, "position:x", original_pos.x, 0.03)
	await tween.finished
	is_denied_effect_active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and GM.in_revision_area and GM.can_check:
		if not GM.checking:
			check_windows_animation.play("appears")
			GM.checking = true
			exit_button.disabled = false
		else:
			check_windows_animation.play_backwards("appears")
			GM.checking = false
			exit_button.disabled = true
 
func _on_exit_button_pressed() -> void:
	check_windows_animation.play_backwards("appears")
	GM.checking = false
	exit_button.disabled = true
