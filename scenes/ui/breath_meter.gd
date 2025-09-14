extends Control

func _ready():
	_on_breath_updated(BreathManager.breath)
	_on_max_breath_updated(BreathManager.max_breath)
	
	BreathManager.breath_updated.connect(_on_breath_updated)
	BreathManager.max_breath_updated.connect(_on_max_breath_updated)

func _on_breath_updated(new_breath: float):
	$BreathBar.value = new_breath
	
func _on_max_breath_updated(new_max_breath: float):
	$HurtBar.value = 1.0 - new_max_breath
