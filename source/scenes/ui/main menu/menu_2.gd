extends Control

const MAIN_SCENE = preload("res://scenes/main.tscn")

@onready
var anim_player: AnimationPlayer = $AnimationPlayer
@onready
var theme_player: AudioStreamPlayer = $ThemePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Sure, whatever. Not sure why get_tree().root doesn't work here.
	theme_player.reparent(BreathManager)
	anim_player.play("IntroAnimation")

func _on_begin():
	get_tree().change_scene_to_packed(MAIN_SCENE)

func _on_quit():
	get_tree().quit()

func _start_music():
	theme_player.play()
