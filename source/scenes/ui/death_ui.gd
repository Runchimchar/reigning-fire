extends Control

const DEATH_TREASURE_TEXT = "You hoarded %d pieces treasure"
const DEATH_TIME_TEXT1 = "Your reign of terror lasted %d minute"
const DEATH_TIME_TEXT2 = " and %d second"

var death_time: int

func _ready():
	BreathManager.max_breath_updated.connect(_check_death)

func _check_death(value: float):
	if value > 0.0:
		return
	
	# We died!
	death_time = Time.get_ticks_msec()
	build_text()
	visible = true
	
	# Hide some UI stuff.
	for item: CanvasItem in get_tree().get_nodes_in_group("hide_on_death"):
		item.visible = false

func build_text():
	var total_msec = death_time - PointsManager.start_time
	var minutes = total_msec / (1000 * 60)
	var seconds = (total_msec / 1000) % 60
	
	$VBoxContainer/Label.text = DEATH_TIME_TEXT1 % minutes + ("s" if minutes != 1 else "") \
		+ DEATH_TIME_TEXT2 % seconds + ("s" if seconds != 1 else "") \
		+ "\n" \
		+ DEATH_TREASURE_TEXT % PointsManager.points \
		+ "\n\n Will you reign again?\n "

func _restart():
	get_tree().reload_current_scene()

func _quit():
	get_tree().quit()
