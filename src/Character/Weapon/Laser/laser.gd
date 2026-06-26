extends Area2D

var SPEED: float = 600.0
var onscreen: bool = false
var damage: float = 2.0

var screen_notifer = VisibleOnScreenNotifier2D.new()

func _ready() -> void:
	add_child(screen_notifer)

func _process(delta: float) -> void:
	global_position += transform.x * SPEED * delta
	if screen_notifer.is_on_screen():
		onscreen = true
	
	if not screen_notifer.is_on_screen():
		if onscreen:
			queue_free()
