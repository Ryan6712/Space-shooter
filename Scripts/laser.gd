extends Area2D

var SPEED: float = 400.0
#var cursor_position

func _ready() -> void:
	#cursor_position = get_global_mouse_position()
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	global_position += transform.x * SPEED * delta
