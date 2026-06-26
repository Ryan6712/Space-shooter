extends Node2D

@onready var buff_spawn_timer: Timer = $BuffSpawnTimer
@onready var meteor_spawn: Timer = $MeteorSpawnTimer
@onready var player: CharacterBody2D = $Player
#@onready var ui: CanvasLayer = $UI


var MeteorScenes: Dictionary[String, PackedScene] = {
	"big" : load("res://src/Meteor/Scenes/meteor_big.tscn"),
	"med" : load("res://src/Meteor/Scenes/meteor_med.tscn"),
	"small" : load("res://src/Meteor/Scenes/meteor_small.tscn"),
	"tiny" : load("res://src/Meteor/Scenes/meteor_tiny.tscn")
}


var BuffScenes: PackedScene = load("res://src/Buffs/Buffs.tscn")
var stats = PlayerBase.new(100.0, 100.0, 500)

var HP = stats.HP
var MAX_HP = stats.max_HP

signal speed_up

func _ready() -> void:
	
	get_tree().call_group('ui', 'set_health', HP, MAX_HP)
	Global.reset()
	buff_spawn_timer.wait_time = _set_buff_timer()
	stats.HP_change.connect(on_hp_change)
	stats.died.connect(on_die)
	


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
		meteor_spawn.set_wait_time(0.1)
	
	
	
	
func _on_meteor_spawn_timer_timeout() -> void:
	var randomSize: PackedScene = MeteorScenes.values().pick_random()
	var meteor:  = randomSize.instantiate()
	$Meteors.add_child(meteor)
	meteor.connect("collision", _on_meteor_collision)
	meteor.connect("heal", heal_meteor)


func _on_meteor_collision(damage):
	stats.take_damage(damage)
	$SFXs/on_hit_sfx.play()


func heal_meteor(amount):
	stats.heal(amount)

func on_die() -> void:
	Engine.time_scale = 0.5
	$SFXs/on_death_sfx.play()
	$DeathTimer.start()


func _on_player_laser(pos: Variant) -> void:
	var laserScenes: PackedScene = load("res://src/Character/Weapon/Laser/laser.tscn")
	var laser := laserScenes.instantiate()
	$Lasers.add_child(laser)
	laser.global_transform = pos
	

func on_hp_change(updated_HP, max_HP) -> void:
	get_tree().call_group('ui', 'set_health', updated_HP, max_HP)

func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().call_deferred("change_scene_to_file", "res://src/UI/Menu/Game_over/Scene/game_over.tscn")




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
			#print("buff masuk")
			MAX_HP += 2
		#"shield":
			#SHIELD += 2
		"speed":
			#print("masuk")
			speed_up.emit()
