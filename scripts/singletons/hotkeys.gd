extends Node
var last_window_mode: DisplayServer.WindowMode
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(last_window_mode)
		else:
			last_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
