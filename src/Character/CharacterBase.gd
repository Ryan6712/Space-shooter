extends Object
class_name CharacterBase
 
@export var max_HP :float
@export var HP :float
@export var speed :int

var is_alive: bool

signal HP_change(HP: float, max_HP: float)
signal died

func _init(val_max_HP, val_hp, val_speed,) -> void:
	max_HP = val_max_HP
	HP = val_hp
	speed = val_speed
	is_alive = true

func heal(amount: float) -> void:
	if not is_alive:
		return
	
	HP += amount
	HP = min(HP, max_HP)
	HP_change.emit(HP, max_HP)

func take_damage(amount: float) -> void:
	if not is_alive:
		return
		
	HP -= amount
	HP = max(HP, 0)
	HP_change.emit(HP, max_HP)
	
	if HP <= 0:
		die()

func die() -> void:
	if is_alive and HP > 0:
		return
	
	is_alive = false
	died.emit()
