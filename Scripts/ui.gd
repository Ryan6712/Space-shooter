extends CanvasLayer


static var HpImage = load("res://Assets/UI/bar.png")

@onready var ammo: Label = $PlayerBar/VBoxContainer/Ammo
@onready var hp_bar: ProgressBar = $"PlayerBar/VBoxContainer/HP Bar"

var second: int = 0
var minute: int = 0

var stats


func _ready() -> void:
	var level = get_parent()
	stats = level.stats
	
	stats.ammo_change.connect(set_ammo)
	stats.is_on_reload.connect(reload)
	
	set_ammo(stats.current_ammo, stats.max_ammo)

func set_health(amount, max_hp):
	hp_bar.max_value = max_hp
	hp_bar.value = amount


func set_ammo(current_ammo, max_ammo) -> void :
	ammo.text = "%d : %d" % [current_ammo, max_ammo]

func reload(condition) -> void:
	if condition == true:
		ammo.text = "Reloading"
		return
	set_ammo(stats.current_ammo, stats.max_ammo)

func _on_timer_score_timeout() -> void:
	
	Global.time_elipse += 1
	second += 1
	
	
	if Global.time_elipse < 120:
		Global.score += 1
	elif Global.time_elipse < 5000:
		Global.score += 2
	else :
		Global.score += 3
	
	if second % 60 == 0:
		second = 0
		minute += 1
	
	
	
	$Time/Label.text = "%02d:%02d" % [minute, second]
	$Score/Score.text = str(Global.score)
