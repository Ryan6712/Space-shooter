extends Area2D

@export var textureList : Array[Texture2D]

@onready var destroy_animation := $AnimationPlayer

var SPEED: int
var ROTATION_SPEED: int
var DIRECTION_x: float


signal collision

func _ready() -> void:
	var rnd := RandomNumberGenerator.new()
	var width := int(get_viewport().get_visible_rect().size[0])
	var random_x := rnd.randi_range(0, width)
	var random_y := rnd.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	$Sprite2D.texture = textureList[rnd.randi_range(0, textureList.size()-1)]
	SPEED = rnd.randi_range(200, 500)
	ROTATION_SPEED = rnd.randi_range(40, 100)
	DIRECTION_x = rnd.randf_range(-1, 1)

	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	
	position += Vector2(DIRECTION_x, 1.0) * SPEED * delta
	rotation_degrees += ROTATION_SPEED * delta
	
func _on_body_entered(_body: Node2D) -> void:
	collision.emit()

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	destroy_animation.play("destroy")
	Global.score += 10
