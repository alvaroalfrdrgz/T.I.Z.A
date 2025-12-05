extends CanvasLayer

@onready var reputation: Label = $Reputation

func _process(_delta: float) -> void:
	reputation.text = str(GM.reputation)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
