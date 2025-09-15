extends Node

const INITIAL_BREATH = 0.0
const INITIAL_MAX_BREATH = 1.0

func _ready():
	# Handle scene restarts.
	get_tree().current_scene.tree_exiting.connect(_handle_restart)

# Emitted when the breath value changes
signal breath_updated(breath: float)
var breath: float = 0.0:
	get:
		return breath
	set(value):
		# Limit to max breath.
		value = clamp(value, 0.0, max_breath)
		# Only update if can update.
		if value != breath:
			breath = value
			breath_updated.emit(value)

# Emitted when the max_breath value changes
signal max_breath_updated(max_breath: float)
var max_breath: float = 1.0:
	get:
		return max_breath
	set(value):
		# Clamp breath to max.
		breath = min(value, breath)
		# Clamp max between 0 and 1.
		value = clamp(value, 0.0, 1.0)
		max_breath = value
		max_breath_updated.emit(value)

func _handle_restart():
	print("Breath manager restarting...")
	breath = INITIAL_BREATH
	max_breath = INITIAL_MAX_BREATH
	get_tree().node_added.connect(_handle_new_scene)

func _handle_new_scene(node: Node):
	# Set up with new scene
	get_tree().node_added.disconnect(_handle_new_scene)
	get_tree().current_scene.tree_exiting.connect(_handle_restart)
	print("Breath manager restarted")
