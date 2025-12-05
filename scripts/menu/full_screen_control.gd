extends CheckButton

func _ready():
	if not Engine.is_editor_hint():
		var current_mode = DisplayServer.window_get_mode()
		self.set_pressed_no_signal(current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN)
		self.toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool) -> void:
	if not Engine.is_editor_hint():
		if toggled_on:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			#ProjectSettings.set_setting("display/window/size/mode", "fullscreen")
		#else:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#ProjectSettings.set_setting("display/window/size/mode", "windowed")
			#ProjectSettings.save()
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
