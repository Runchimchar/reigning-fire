extends Area2D

const EXPLOSION_AUDIO = preload("res://assets/sounds/explosion_filtered.wav")

const SPEED: int = 1800
const LIFETIME: float = 3.0

var lifetime: float = LIFETIME
var direction: Vector2

func _ready():
	direction = Vector2.from_angle(rotation)

func _process(delta):
	# Check lifetime.
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	
	# Move forward.
	position += direction * SPEED * delta

var freed = false
func _on_area_entered(area: Area2D):
	# Only care about breakable objects.
	if area.is_in_group('breakable') and area._try_break() and not freed:
		SfxHelper.Play(EXPLOSION_AUDIO, get_tree().root, randf_range(0.9, 1.1))
		SfxHelper.Burst($Explosion, get_tree().root)
		freed = true
		queue_free()
