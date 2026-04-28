extends Control

@export var lavel_scenes: PackedScene
var score = Score.new()


func _ready() -> void:
	load_score()
	$MarginContainer/Label.text = $MarginContainer/Label.text + str(score.Highest_score)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		_on_button_pressed()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(lavel_scenes)

func load_score():
	score = ResourceLoader.load(Global.save_file_path + Global.save_score, "", ResourceLoader.CACHE_MODE_IGNORE)
	
func _on_exit_button_button_down() -> void:
	get_tree().quit()
