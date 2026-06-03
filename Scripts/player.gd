extends CharacterBody2D


@export var SPEED := 450
@export var laser_cooldown_timer:float = 0.8
@onready var buff_icons: HBoxContainer = %BuffIcons
@onready var speed_buff_timer: Timer = $SpeedBuffTimer

var speed_now := SPEED
var can_shoot:bool = true
var is_speed_buffed:bool = false
var buff_time: float = 5.0
signal Laser(pos)

func _ready() -> void:
	var level_node = get_parent()
	speed_buff_timer.wait_time = buff_time
	if level_node and level_node.has_signal("speed_up"):
		level_node.speed_up.connect(_on_speed_up)
		
	for child in buff_icons.get_children():
		child.queue_free()
	

#called every frame that rendered
func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	$LaserCooldown.wait_time = laser_cooldown_timer
	
	velocity = direction * speed_now 
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		Laser.emit($LaserStartPoint.global_position)
		can_shoot = false
		$LaserCooldown.start()
		$LaserSound.play()
	


func _on_laser_cooldown_timeout() -> void:
	can_shoot = true


func _on_speed_up() -> void:
	if !is_speed_buffed:
		is_speed_buffed = true
		speed_now += 200
		var texture = TextureRect.new()
		texture.texture = load("res://Assets/Buff Icons/speed.png")
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture.name = "SpeedIcon"
		buff_icons.add_child(texture)
		
		print("buff beneran masuk")
		$SpeedBuffTimer.start()
	else:
		print("lu sudah ke buff jadi gak bisa stack buff tapi akan aku reset timernya")
		$SpeedBuffTimer.start()
	
func _on_speed_buff_timer_timeout() -> void:
	if is_speed_buffed:
		speed_now = SPEED
		is_speed_buffed = false
		var icon = get_node("%BuffIcons/SpeedIcon")
		if icon :
			icon.queue_free()
	
