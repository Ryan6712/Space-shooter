extends Object

class_name MeteorBase

var hp: float
var is_can_heal: bool
var damage: float
var heal_value: float
var score: int

signal on_hp_change(hp)

func _init(size: String) -> void:
	match size :
		"meteor_big":
			hp = 10
			damage = 8
			heal_value = 3
			score = 15
		"meteor_med":
			hp = 5
			damage = 6
			heal_value = 2
			score = 8
		"meteor_small":
			hp = 3
			damage = 4
			heal_value = 1
			score = 5
		"meteor_tiny":
			hp = 1
			damage = 1
			heal_value = 1
			score = 3

func get_hit(amount) -> void:
	hp -= amount
	hp = max(hp, 0)
	on_hp_change.emit(hp)

func destroy(animation: AnimationPlayer) -> void:
	if hp <= 0:
		animation.play("destroy")
		Global.score += score

func set_heal(particle: GPUParticles2D):
	var option = [false, true]
	var chance = PackedFloat32Array([95, 5]) 
	var index = Global.rnd.rand_weighted(chance)
	
	is_can_heal = option[index]
	
	if particle :
		if not is_can_heal :
			particle.emitting = false
		else :
			particle.emitting = true
