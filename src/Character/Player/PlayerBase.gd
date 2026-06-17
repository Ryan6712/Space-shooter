extends CharacterBase
class_name PlayerBase

var max_ammo: int = 20
var current_ammo: int = 20
var can_shoot: bool
var level: int = 1
signal ammo_change(current_ammo: int, max_ammo: int)

func shoot() -> void:
	if current_ammo < 0 :
		can_shoot = false
		reload()
		return
		
	if not can_shoot:
		return
	
	current_ammo -= 1
	current_ammo = min(current_ammo, max_ammo)
	ammo_change.emit(current_ammo, max_ammo)

func reload() -> void:
	current_ammo = max_ammo
	ammo_change.emit(current_ammo, max_ammo)
