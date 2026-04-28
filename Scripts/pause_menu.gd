extends CanvasLayer


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit") and get_tree().paused == true:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
	if Input.is_action_just_pressed("play"):
		_toggle_pause()

func _toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
