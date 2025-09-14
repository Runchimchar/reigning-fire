extends Node

const INITIAL_POINTS = 0

var start_time: int

func _ready():
	# Starting time of rampage.
	start_time = Time.get_ticks_msec()
	# Handle scene restarts.
	get_tree().current_scene.tree_exited.connect(_handle_restart)

# Emitted when the points value changes
signal points_updated(breath: float)
var points: int = 0:
	get:
		return points
	set(value):
		points = value
		points_updated.emit(value)

func _handle_restart():
	print("Points manager restarting...")
	start_time = Time.get_ticks_msec()
	points = INITIAL_POINTS
	get_tree().node_added.connect(_handle_new_scene)

func _handle_new_scene(node: Node):
	# Set up with new scene
	get_tree().node_added.disconnect(_handle_new_scene)
	get_tree().current_scene.tree_exited.connect(_handle_restart)
	print("Points manager restarted")
