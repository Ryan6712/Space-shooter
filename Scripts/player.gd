extends CharacterBody2D


@export var laser_cooldown_timer:float = 0.8
@onready var buff_icons: HBoxContainer = %BuffIcons
@onready var speed_buff_timer: Timer = $SpeedBuffTimer

var stats
signal Laser(pos)

func _ready() -> void:
	var level = get_parent()
	stats = level.stats

#called every frame that rendered
func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	$LaserCooldown.wait_time = laser_cooldown_timer
	
	velocity = direction * stats.speed
	move_and_slide()
	
	
	
	if Input.is_action_just_pressed("shoot"):
		Laser.emit($LaserStartPoint.global_position)
		$LaserCooldown.start()
		$LaserSound.play()
	

#func _on_laser_cooldown_timeout() -> void:
	#can_shoot = true



	
