extends Area2D

@export var buffTextureList: Array[Texture2D]
@onready var buff_icon: Sprite2D = $BuffIcon


var SPEED: int
var DIRECTION_x: float
var buffName: String

signal buff(buff_type: String)

func _ready() -> void:
	_buff_rate_chances()
	var width := int(get_viewport().get_visible_rect().size[0])
	var random_x := Global.rnd.randi_range(0, width)
	var random_y := Global.rnd.randi_range(-100, -50)
	position = Vector2(random_x, random_y)
	buffName = buff_icon.texture.resource_path.get_file().get_basename()
	
	print(buffName)
	
	SPEED = Global.rnd.randi_range(200, 500)
	DIRECTION_x = Global.rnd.randf_range(-1, 1)


	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position += Vector2(DIRECTION_x, 1.0) * SPEED * delta


func _buff_rate_chances() -> void:
	var chance = PackedFloat32Array([45, 30, 15, 10]) 
	var index = Global.rnd.rand_weighted(chance)
	
	#buff_icon.texture = buffTextureList[index]
	buff_icon.texture = load("res://Assets/Buff Icons/speed.png")


func _on_body_entered(_body: Node2D) -> void:
	buff.emit(buffName)
	queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	buff.emit(buffName)
	queue_free()
	area.queue_free()
