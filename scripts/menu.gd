extends CanvasLayer

@onready var play: Button = $MainButtons/Play
@onready var exit: Button = $MainButtons/Exit
@onready var menu: CanvasLayer = $"."

func _on_play_button_down() -> void:
	GM.time_start = 1
	SG.game_started = true
	menu.visible = false
