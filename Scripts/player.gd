extends CharacterBody2D

@onready var buff_icons: HBoxContainer = %BuffIcons
@onready var speed_buff_timer: Timer = $SpeedBuffTimer
@onready var laser_start_point: Marker2D = $Sprite2D/LaserStartPoint


@export var	fire_rate_cooldown: float
@export var rotation_speed: float = 10.0
@export_range(0.0, 0.1, 0.01) var handle_weigth = 0.3


var target_velocity: Vector2 = Vector2.ZERO
var stats
signal Laser(position, rotation)

func _ready() -> void:
	var level = get_parent()
	stats = level.stats
	#stats.dash_cooldown_timer = stats.dash_cooldown


#called every frame that rendered
func _process(delta: float) -> void:
	
	if stats:
		stats.dash_cooldown_update(delta)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	var cursor_position = get_global_mouse_position()
	var target_angle = global_position.angle_to_point(cursor_position)
	
	if Input.is_action_just_pressed("boost") and stats:
		stats.dash(direction, self)
	
	if stats and stats.on_dash:
		velocity = velocity.lerp(target_velocity, stats.dash_handle_weight)
	else:
		rotation = rotate_toward(rotation, target_angle, rotation_speed * delta	)
		velocity = direction * stats.speed
		velocity = velocity.lerp(target_velocity, handle_weigth)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
	
	if fire_rate_cooldown > 0:
		fire_rate_cooldown -= delta
		
	move_and_slide()

		

func shoot() -> void:
	if fire_rate_cooldown > 0:
		return
	
	stats.shoot()
	
	if not stats.can_shoot:
		reload()
		return
	
	
	Laser.emit(laser_start_point.global_transform)
	$LaserSound.play()
	fire_rate_cooldown = stats.fire_rate

func reload() -> void:
	stats.reload(self)
