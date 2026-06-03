extends Node2D

var MeteorScenes: Dictionary[String, PackedScene] = {
	"big" : load("res://Scenes/Meteor/meteor_big.tscn"),
	"med" : load("res://Scenes/Meteor/meteor_med.tscn"),
	"small" : load("res://Scenes/Meteor/meteor_small.tscn"),
	"tiny" : load("res://Scenes/Meteor/meteor_tiny.tscn")
}
var BuffScenes: PackedScene = load("res://Scenes/Buffs.tscn")

var HP := 3
var MAX_HP := 10
var SHIELD := 0

@onready var buff_spawn_timer: Timer = $BuffSpawnTimer
@onready var meteor_spawn: Timer = $MeteorSpawnTimer


signal speed_up

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().call_group('ui', 'set_health', HP)
	Global.reset()
	buff_spawn_timer.wait_time = _set_buff_timer()
	

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	if Global.time_elipse < 30:
		meteor_spawn.set_wait_time(1)
	elif Global.time_elipse < 60:
		meteor_spawn.set_wait_time(0.8)
	elif Global.time_elipse < 80:
		meteor_spawn.set_wait_time(0.5)
	elif Global.time_elipse < 120:
		meteor_spawn.set_wait_time(0.3)
	else:
		meteor_spawn.set_wait_time(0.2)
	
	
	
	
func _on_meteor_spawn_timer_timeout() -> void:
	var randomSize: PackedScene = MeteorScenes.values().pick_random()
	var meteor:  = randomSize.instantiate()
	$Meteors.add_child(meteor)
	meteor.connect("collision", _on_meteor_collision)
	meteor.connect("heal", heal_meteor)


func _on_meteor_collision():
	if SHIELD > 0:
		SHIELD -= 1
	else :
		HP -= 1
		
	$SFXs/on_hit_sfx.play()
	get_tree().call_group('ui', 'set_health', HP)
	if HP <= 0:
		Engine.time_scale = 0.5
		$SFXs/on_death_sfx.play()
		$DeathTimer.start()
		

func heal_meteor():
	if  HP <= MAX_HP:
		HP += 1
		$SFXs/on_heal_sfx.play()
		get_tree().call_group('ui', 'set_health', HP)
	else :
		print("can't heal because max")

func _on_player_laser(pos: Variant) -> void:
	var laserScenes: PackedScene = load("res://Scenes/laser.tscn")
	var laser := laserScenes.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos


func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")

func _set_buff_timer() -> float:
	var time = Global.rnd.randf_range(1.0, 3.0)
	return time

func _on_buff_spawn_timer_timeout() -> void:
	var buffScenes = BuffScenes.instantiate()
	$Buffs.add_child(buffScenes)
	buffScenes.connect("buff", _handle_buff)
	buff_spawn_timer.wait_time = _set_buff_timer()

func _handle_buff(buff_type: String) -> void:
	match buff_type:
		"max_health":
			print("buff masuk")
			MAX_HP += 2
		"shield":
			SHIELD += 2
		"speed":
			print("masuk")
			speed_up.emit()
