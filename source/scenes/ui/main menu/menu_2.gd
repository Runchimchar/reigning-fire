extends Control

const MAIN_SCENE = preload("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("IntroAnimation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_begin():
	get_tree().change_scene_to_packed(MAIN_SCENE)

func _on_quit():
	get_tree().quit()

func _start_music():
	# Sure, whatever.
	$ThemePlayer.play()
	$ThemePlayer.reparent(BreathManager)
