class_name UI
extends Control

@onready var professor_name: Label = $ProfessorStats/ProfessorName
@onready var cintra_amount: Label = $ProfessorStats/CintraAmount
@onready var cintra_bar: TextureProgressBar = $ProfessorStats/CintraBar
@onready var professor_picture: TextureRect = $ProfessorStats/ProfessorPicture
@onready var cintra_picture: TextureRect = $ProfessorStats/CintraPicture
@onready var stamina_bar: TextureProgressBar = $ProfessorStats/StaminaBar
@onready var stamina_text: Label = $ProfessorStats/StaminaText


func _process(_delta: float) -> void:
	cintra_amount.text = "X" + str(GM.cintra)
	#stamina_bar.value = professor
	#cintra_time_bar.value = professor.remaining_cintra_time
	
	#if professor.stamina < 20:
		#create_tween().tween_property(stamina_bar, "tint_progress", Color(18.892, 0.0, 0.0, 1.0),0.1)
	#else:
		#create_tween().tween_property(stamina_bar, "tint_progress", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	#
	#if Input.is_action_just_released("item"):
		#if GM.cintra <= 0:
			#_play_denied_effect()
#
#func _play_denied_effect():
	#if is_denied_effect_active:
		#return
	#
	#is_denied_effect_active = true
	#
	#var original_pos = cintra_time_bar.position
	#var tween = create_tween()
	#
	#tween.tween_property(cintra_time_bar, "position:x", original_pos.x + 4, 0.03)
	#tween.tween_property(cintra_time_bar, "position:x", original_pos.x - 4, 0.03)
	#tween.tween_property(cintra_time_bar, "position:x", original_pos.x + 4, 0.03)
	#tween.tween_property(cintra_time_bar, "position:x", original_pos.x, 0.03)
	#await tween.finished
	#
	#is_denied_effect_active = false
