extends Area2D

@export var textureList : Array[Texture2D]
@onready var destroy_animation := $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var hp_bar: ProgressBar = $HPBar

var SPEED: int
var ROTATION_SPEED: int
var DIRECTION_x: float
var size: String
var onscreen: bool = false
var meteor_stats: MeteorBase

var screen_notifer = VisibleOnScreenNotifier2D.new()


signal collision(damage)
signal heal(value)

func _ready() -> void:
	var width := int(get_viewport().get_visible_rect().size[0])
	var random_x := Global.rnd.randi_range(0, width)
	var random_y := Global.rnd.randi_range(-100, -50)
	position = Vector2(random_x, random_y)
	SPEED = Global.rnd.randi_range(200, 500)
	ROTATION_SPEED = Global.rnd.randi_range(40, 100)
	DIRECTION_x = Global.rnd.randf_range(-1, 1)
	
	add_child(screen_notifer)
	
	$Sprite2D.texture = textureList[Global.rnd.randi_range(0, textureList.size()-1)]
	var path = scene_file_path
	size = path.get_file().get_basename()
	
	meteor_stats = MeteorBase.new(size)
	
	meteor_stats.set_heal(gpu_particles_2d)
	
	meteor_stats.on_hp_change.connect(on_hp_change)
	
	hp_bar.max_value = meteor_stats.hp
	hp_bar.value = meteor_stats.hp
	hp_bar.visible = false

func _process(delta: float) -> void:
	position += Vector2(DIRECTION_x, 1.0) * SPEED * delta
	rotation_degrees += ROTATION_SPEED * delta
	
	
	if screen_notifer.is_on_screen():
		onscreen = true
	
	if not screen_notifer.is_on_screen():
		if onscreen:
			queue_free()

	
	
func _on_body_entered(_body: Node2D) -> void:
	collision.emit(meteor_stats.damage)

func _on_area_entered(area: Area2D) -> void:
	meteor_stats.get_hit(area.damage)
	 
		
	area.queue_free()
	if meteor_stats.hp <= 0:
		
		if meteor_stats.is_can_heal == true:
			heal.emit(meteor_stats.heal_value)
			
		meteor_stats.destroy(destroy_animation)
	
func on_hp_change(value) -> void:
	if hp_bar:
		hp_bar.visible = true
		hp_bar.value = value
	
