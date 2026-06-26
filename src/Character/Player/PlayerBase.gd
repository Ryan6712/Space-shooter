extends CharacterBase
class_name PlayerBase

var level: int = 1

@export var max_ammo: int = 20
@export var fire_rate: float = 0.2
var current_ammo: int = max_ammo
var can_shoot: bool = true

@export var reload_time: float = 2.0
var is_reloading: bool = false

@export var dash_cooldown: float = 3.0
@export var dash_speed: float = 1500.0
@export var dash_leght: float = 0.4
@export_range(0.0, 0.1, 0.01) var dash_handle_weight: float = 0.04
var dash_cooldown_timer: float = 0.0
var on_dash:bool = false

signal ammo_change(current_ammo: int, max_ammo: int)
signal fire_rate_change(fire_rate: float)
signal is_on_reload(condition: bool)
signal level_up(new_level: int)

func shoot() -> bool:
	if current_ammo <= 0 or is_reloading:
		can_shoot = false
		return can_shoot
	
	current_ammo -= 1
	current_ammo = max(current_ammo, 0)
	ammo_change.emit(current_ammo, max_ammo)
	return can_shoot

func reload(node: Node) -> void:
	if current_ammo == max_ammo or is_reloading == true:
		return
	
	is_reloading = true
	is_on_reload.emit(is_reloading)
	await node.get_tree().create_timer(reload_time).timeout
	
	current_ammo = max_ammo
	
	is_reloading = false
	can_shoot = true
	ammo_change.emit(current_ammo, max_ammo)
	is_on_reload.emit(is_reloading)

func dash_cooldown_update(delta: float):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	

func dash_ui_update(bar: Node) -> void:
	bar.max_value = 1.0
	
	if dash_cooldown_timer > 0:
		var left = 1 - (dash_cooldown_timer / dash_cooldown)
		bar.value = left
	else:
		bar.value = dash_cooldown

func dash(arah: Vector2, node: CharacterBody2D) -> void:
	if on_dash == true or dash_cooldown_timer > 0.2:
		return
		
	if arah == Vector2.ZERO:
		arah = Vector2.UP
	
	on_dash = true
	dash_cooldown_timer = dash_cooldown
	node.velocity = arah * dash_speed
	var sfx = node.find_child("DashSound")
	
	if sfx:
		sfx.play()
	
	await node.get_tree().create_timer(dash_leght).timeout
	on_dash = false


func on_level_up() -> void:
	level += 1
	current_ammo += 5
	fire_rate -= 0.1
	level_up.emit(level)
	ammo_change.emit(current_ammo, max_ammo)
	fire_rate_change.emit(fire_rate)
	
