extends CanvasLayer


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("play") and get_tree().paused == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://src/UI/Menu/Start_menu/Scenes/main_menu.tscn")
		
	if Input.is_action_just_pressed("exit"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused


func _on_button_continue_button_down() -> void:
	_toggle_pause()


func _on_button_exit_button_down() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://src/UI/Menu/Start_menu/Scenes/main_menu.tscn")
