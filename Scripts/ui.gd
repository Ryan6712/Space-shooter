extends CanvasLayer

static var HpImage = load("res://Assets/PlayerShips/playerShip1_blue.png")

var second: int = 0
var minute: int = 0

func set_health(amount):
	for child in $"MarginContainer2/HP Bar".get_children():
		child.queue_free()
	
	for i in amount:
		var text_react = TextureRect.new()
		text_react.texture = HpImage
		text_react.expand_mode = 	TextureRect.EXPAND_FIT_WIDTH
		$"MarginContainer2/HP Bar".add_child(text_react)


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
	
	
	
	$MarginContainer3/Label.text = "%02d:%02d" % [minute, second]
	$MarginContainer/Score.text = str(Global.score)
