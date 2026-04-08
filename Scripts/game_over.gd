extends Control

@export var lavel_scenes: PackedScene
@export var menu_scenes: PackedScene

var score: Score = Score.new()
var save_path := Global.save_file_path + Global.save_score

func _ready() -> void:
	$CenterContainer/VBoxContainer/Label2.text = $CenterContainer/VBoxContainer/Label2.text + str(Global.score)
	score = ResourceLoader.load(Global.save_file_path + Global.save_score, "", ResourceLoader.CACHE_MODE_IGNORE)
	verify_save_directory(Global.save_file_path)
	if Global.score > score.Highest_score:
		score.Highest_score = Global.score
		ResourceSaver.save(score, save_path)

func verify_save_directory(path: String):
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_absolute(path)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		get_tree().change_scene_to_packed(lavel_scenes)
	
	if  Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_packed(menu_scenes)
		
