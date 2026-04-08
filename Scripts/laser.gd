extends Area2D

var SPEED = 400

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position.y -= SPEED * delta
