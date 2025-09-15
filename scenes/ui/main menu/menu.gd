extends Control

const MAIN_SCENE = preload("res://scenes/main.tscn")

func _ready():
	# Sure, whatever.
	$ThemePlayer.reparent(BreathManager)
	print("ding!")

func _on_begin():
	get_tree().change_scene_to_packed(MAIN_SCENE)

func _on_quit():
	get_tree().quit()
