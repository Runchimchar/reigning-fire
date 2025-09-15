class_name SfxHelper
extends AudioStreamPlayer

# Creates a audio player for the stream and configures the node to free itself.
static func Play(audio: AudioStream, parent: Node, pitch: float = 1.0, volume: float = 0.0):
	# Create and parent audio player.
	var player = AudioStreamPlayer.new()
	parent.add_child(player)
	
	# Configure player.
	player.stream = audio.duplicate(true)
	player.pitch_scale = pitch
	player.volume_db = volume
	
	# Configure freeing and start.
	player.finished.connect(func(): player.queue_free())
	player.play()

# Copies the template particles and configures the new node to free itself.
static func Burst(template: CPUParticles2D, parent: Node):
	# Create and parent particles, copying global position/scale/etc.
	var new_particles: CPUParticles2D = template.duplicate()
	new_particles.global_transform = template.global_transform
	parent.add_child(new_particles)
	
	# Configure freeing and start.
	new_particles.finished.connect(func(): new_particles.queue_free())
	new_particles.restart()
