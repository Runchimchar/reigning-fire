extends Node2D

# Most logic from: https://shaggydev.com/2022/02/23/screen-shake-godot/

# How quickly to move through the noise
const DEF_NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
const DEF_NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
const DEF_SHAKE_DECAY_RATE: float = 5.0

var camera: Camera2D
var rand: RandomNumberGenerator
var noise: Noise

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

var strength: float = 0.0
var speed: float = 0.0
var decay: float = 0.0

func _ready() -> void:
	# Handle scene restarts.
	get_tree().current_scene.tree_exiting.connect(_handle_restart)
	
	# Refresh current camera.
	update_camera()
	
	# Setup randomizer.
	rand = RandomNumberGenerator.new()
	rand.randomize()
	
	# Setup noise.
	noise = FastNoiseLite.new()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Frequency? affects how quickly the noise changes values
	noise.frequency = 0.2

# Shake the screen.
func shake_screen(speed: float = -1, strength: float = -1, decay: float = -1):
	self.speed = DEF_NOISE_SHAKE_SPEED if speed <= 0 else speed
	self.strength = DEF_NOISE_SHAKE_STRENGTH if strength <= 0 else strength
	self.decay = DEF_SHAKE_DECAY_RATE if decay <= 0 else decay

func _process(delta: float):
	# Fade out the intensity over time
	strength = lerp(strength, 0.0, decay * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	if camera == null:
		update_camera()
	else:
		camera.offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func update_camera():
	camera = get_viewport().get_camera_2d()

func _handle_restart():
	print("Screen shaker restarting...")
	strength = 0.0
	get_tree().node_added.connect(_handle_new_scene)

func _handle_new_scene(node: Node):
	# Set up with new scene
	get_tree().node_added.disconnect(_handle_new_scene)
	get_tree().current_scene.tree_exiting.connect(_handle_restart)
	update_camera()
	print("Screen shaker restarted")
