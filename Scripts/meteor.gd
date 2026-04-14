extends Area2D

@export var textureList : Array[Texture2D]
@onready var destroy_animation := $AnimationPlayer

var SPEED: int
var ROTATION_SPEED: int
var DIRECTION_x: float
var is_can_heal: bool

signal collision
signal heal

func _ready() -> void:
	var width := int(get_viewport().get_visible_rect().size[0])
	var random_x := Global.rnd.randi_range(0, width)
	var random_y := Global.rnd.randi_range(-100, -50)
	position = Vector2(random_x, random_y)
	
	$Sprite2D.texture = textureList[Global.rnd.randi_range(0, textureList.size()-1)]
	
	SPEED = Global.rnd.randi_range(200, 500)
	ROTATION_SPEED = Global.rnd.randi_range(40, 100)
	DIRECTION_x = Global.rnd.randf_range(-1, 1)
	heal_chances()
	
	if is_can_heal == false:
		$GPUParticles2D.emitting = false
	else :
		$GPUParticles2D.emitting = true

	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position += Vector2(DIRECTION_x, 1.0) * SPEED * delta
	rotation_degrees += ROTATION_SPEED * delta
	
func _on_body_entered(_body: Node2D) -> void:
	collision.emit()

func _on_area_entered(area: Area2D) -> void:
	if is_can_heal == true:
		heal.emit()
		
	area.queue_free()
	destroy_animation.play("destroy")
	Global.score += 10


func heal_chances():
	var option = [false, true]
	var chance = PackedFloat32Array([95, 5]) 
	var index = Global.rnd.rand_weighted(chance)
	
	is_can_heal = option[index]
	
	
	
