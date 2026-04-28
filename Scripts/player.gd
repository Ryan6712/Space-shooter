extends CharacterBody2D


@export var SPEED := 350
@export var laser_cooldown_timer:float = 0.8

var can_shoot:bool = true

signal Laser(pos)

#called every frame that rendered
func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	$LaserCooldown.wait_time = laser_cooldown_timer
	
	velocity = direction * SPEED 
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		Laser.emit($LaserStartPoint.global_position)
		can_shoot = false
		$LaserCooldown.start()
		$LaserSound.play()


func _on_laser_cooldown_timeout() -> void:
	can_shoot = true
