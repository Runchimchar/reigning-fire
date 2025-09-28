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
	
	# On web, wait for focus to play, to avoid autoplay audio bug.
	if is_web():
		anim_player.play("web_click_anim")
		$WebClickPanel.gui_input.connect(_on_input)
	else:
		start_anim()

func _on_input(event: InputEvent):
	if event is InputEventMouseButton:
		start_anim()

var started: bool = false
func start_anim():
	if not started:
		started = true
		anim_player.play("intro_anim")

func _on_begin():
	get_tree().change_scene_to_packed(MAIN_SCENE)

func _on_quit():
	if is_web():
		JavaScriptBridge.eval("window.close();")
	else:
		get_tree().quit()

func _start_music():
	theme_player.play()

func is_web() -> bool:
	return OS.has_feature("web")
