extends Control

func _ready() -> void:
	await get_tree().create_timer(11).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
