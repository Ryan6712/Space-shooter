extends CanvasLayer


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("play") and get_tree().paused == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
	if Input.is_action_just_pressed("exit"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	if visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else :
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_button_continue_button_down() -> void:
	_toggle_pause()


func _on_button_exit_button_down() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
