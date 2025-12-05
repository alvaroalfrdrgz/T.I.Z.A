class_name UI
extends CanvasLayer

@onready var professor_name: Label = $ProfessorStats/ProfessorName
@onready var cintra_bar: TextureProgressBar = $ProfessorStats/CintraBar
@onready var cintra_picture: TextureRect = $ProfessorStats/CintraPicture
@onready var stamina_bar: TextureProgressBar = $ProfessorStats/StaminaBar
@onready var professor: CharacterBody3D = %Teacher
var is_denied_effect_active: bool = false
@onready var ui: UI = $"."
@onready var professor_stats: Panel = $ProfessorStats

@onready var ceck_windows: Panel = $CeckWindows
@onready var check_windows_animation: AnimationPlayer = $CeckWindows/CheckWindowsAnimation
@onready var exit_button: Button = $CeckWindows/ExitButton
@onready var strike_button: Button = $CeckWindows/ButtonsContainer/StrikeButton
@onready var student_name: Label = $CeckWindows/StudentName
@onready var message: Label = $Message

func _ready() -> void:
	check_windows_animation.play("INIT")
	
	ui.visible = false
	professor_stats.modulate = Color(0.0, 0.0, 0.0, 0.0)
	await get_tree().create_timer(1.15).timeout
	create_tween().tween_property(professor_stats, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
	ui.visible = true

func _process(_delta: float) -> void:
	if GM.active_camera == "cam1":
		student_name.text = "Alvaro"
	elif GM.active_camera == "cam2":
		student_name.text = "Marlon"
	elif GM.active_camera == "cam3":
		student_name.text = "Cintra"
	elif GM.active_camera == "cam4":
		student_name.text = "Dariel"
	elif GM.active_camera == "cam5":
		student_name.text = "Dainel"
	elif GM.active_camera == "cam6":
		student_name.text = "Ana Delia"
	elif GM.active_camera == "cam7":
		student_name.text = "Jesus"
	elif GM.active_camera == "cam8":
		student_name.text = "Amanda"
	elif GM.active_camera == "cam9":
		student_name.text = "Arishel"
		
	stamina_bar.value = professor.stamina
	cintra_bar.value = professor.remaining_cintra_time
	
	if GM.text_active:
		message.text = GM.text
		await get_tree().create_timer(7).timeout
		GM.text_active = false
	else:
		message.text = ""
	
	if GM.cintra == 0:
		zero_item_remain()
	elif GM.cintra == 1:
		one_item_remain()
	elif GM.cintra == 2:
		two_item_remain()
	elif GM.cintra == 3:
		three_item_remain()
	elif GM.cintra == 4:
		four_item_remain()
		
	if professor.stamina < 20:
		stamina_bar.texture_progress = preload("uid://dnwfbvfnus5wu")
	else:
		stamina_bar.texture_progress = preload("uid://2jx3luxplauu")

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
	if Input.is_action_just_released("item"):
		if GM.cintra <= 0:
			play_denied_effect()
			return
		cintra_picture.texture = preload("uid://m332g5dsbk11")
		await get_tree().create_timer(0.5).timeout
		cintra_picture.texture = preload("uid://ctn48337byl50")
	
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

func _on_strike_button_pressed() -> void:
	if GM.active_camera == "cam1":
		GM.student1_strikes += 1
	elif GM.active_camera == "cam2":
		GM.student2_strikes += 1
	elif GM.active_camera == "cam3":
		GM.student3_strikes += 1
	elif GM.active_camera == "cam4":
		GM.student4_strikes += 1
	elif GM.active_camera == "cam5":
		GM.student5_strikes += 1
	elif GM.active_camera == "cam6":
		GM.student6_strikes += 1
	elif GM.active_camera == "cam7":
		GM.student7_strikes += 1
	elif GM.active_camera == "cam8":
		GM.student8_strikes += 1
	elif GM.active_camera == "cam9":
		GM.student9_strikes += 1
		
	strike_button.disabled = true
	await get_tree().create_timer(3).timeout
	strike_button.disabled = false

@onready var one_item: TextureRect = $ProfessorStats/OneItemRemain
@onready var two_item: TextureRect = $ProfessorStats/TwoItemRemain
@onready var three_item: TextureRect = $ProfessorStats/ThreeItemRemain
@onready var four_item: TextureRect = $ProfessorStats/FourItemRemain

func zero_item_remain():
	one_item.visible = false
	two_item.visible = false
	three_item.visible = false
	four_item.visible = false
func one_item_remain():
	one_item.visible = true
	two_item.visible = false
	three_item.visible = false
	four_item.visible = false
func two_item_remain():
	one_item.visible = true
	two_item.visible = true
	three_item.visible = false
	four_item.visible = false
func three_item_remain():
	one_item.visible = true
	two_item.visible = true
	three_item.visible = true
	four_item.visible = false
func four_item_remain():
	one_item.visible = true
	two_item.visible = true
	three_item.visible = true
	four_item.visible = true
