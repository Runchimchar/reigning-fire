extends Area2D

const SPEED: int = 600
const LIFETIME: float = 30.0

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
func _on_body_or_area_entered(thing: Node2D):
	# Only care about hurtable objects.
	if thing.is_in_group('hurtable') and thing._try_hurt(1) and not freed:
		freed = true
		queue_free()
