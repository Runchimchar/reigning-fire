extends Control

const POP_FACTOR: float = 20000.0
const LERP_VAL: float = 0.015
const BASE_FONT_SIZE: float = 40.0
const MAX_FONT_SIZE: float = 80.0

var current_points: int = 0
var total_points: int = 0

func _ready():
	PointsManager.points_updated.connect(_on_points_updated)

# Phys used here for const FPS.
func _physics_process(delta):
	current_points = ceil(lerp(current_points, total_points, LERP_VAL))
	update_text()

func _on_points_updated(points: int):
	total_points = points

func update_text():
	var diff: float = total_points - current_points
	var new_size = round(-POP_FACTOR*(1.0/(diff + (POP_FACTOR/BASE_FONT_SIZE))) + MAX_FONT_SIZE)
	$Label.label_settings.font_size = new_size
	$Label.text = "%d" % current_points
