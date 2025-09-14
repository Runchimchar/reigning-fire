class_name Dragon
extends CharacterBody2D

static var dragon: Dragon = null

const FIREBALL: PackedScene = preload("res://scenes/projectiles/fireball.tscn")
const BLOW_SOUND = preload("res://assets/sounds/blow.wav")
const ROAR_SOUND = preload("res://assets/sounds/roar.wav")

const BASE_SPEED = 300.0
const SPRINT_SPEED = 600.0
const BREATH_RECHARGE = 0.15
const FIREBALL_COST = 0.2
const HURT_PERCENT = 0.34

var bounds: Vector2
var collision_bounds: Vector2
var alive: bool = true

func _ready():
	dragon = self
	var temp_collision_bounds = $CollisionShape2D.shape.get_rect().size * scale
	collision_bounds = Vector2(temp_collision_bounds.y, temp_collision_bounds.x)
	get_viewport().size_changed.connect(update_bounds)
	update_bounds()

func _physics_process(delta):
	# Handle "sprinting"
	var speed = SPRINT_SPEED if is_sprinting() else BASE_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	if alive:
		var x_direction = Input.get_axis("move_left", "move_right")
		if x_direction:
			velocity.x = x_direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
		var y_direction = Input.get_axis("move_up", "move_down")
		if y_direction:
			velocity.y = y_direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
	else:
		# Dead movement
		var dead_speed = 100
		const VARIANCE: float = 8.0
		velocity = Vector2.from_angle((3.5/4.0)*PI + randf_range(-PI/VARIANCE, PI/VARIANCE)) \
			* dead_speed

	move_and_slide()
	
	# Clamp player to screen limits
	if alive:
		clamp_to_bounds()
	
	# Increase breath meter (watch out for FPS!), if not sprinting.
	if not is_sprinting():
		BreathManager.breath += BREATH_RECHARGE * delta

# Handle mouse / debug events.
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			try_create_fireball(event.global_position)
	elif event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_KP_ADD:
			BreathManager.max_breath += 0.34
		if event.keycode == KEY_KP_SUBTRACT:
			_try_hurt(1)

func try_create_fireball(target: Vector2):
	if BreathManager.breath < FIREBALL_COST or not alive:
		return
	else:
		BreathManager.breath -= FIREBALL_COST
	
	var fireball = FIREBALL.instantiate()
	fireball.global_position = $FireSource.global_position
	fireball.rotation = $FireSource.global_position.angle_to_point(target)
	add_sibling(fireball)
	SfxHelper.Play(BLOW_SOUND, self, randf_range(0.9, 1.1))

# Should use breath later
func is_sprinting():
	return Input.is_action_pressed("move_sprint")

func update_bounds():
	bounds = get_viewport().get_visible_rect().size

func clamp_to_bounds():
	global_position.x = clamp(global_position.x, collision_bounds.x/2, bounds.x-collision_bounds.x/2)
	global_position.y = clamp(global_position.y, collision_bounds.y/2, bounds.y-collision_bounds.y/2)

# Required by 'hurtable' group.
func _try_hurt(hurt: int) -> bool:
	if hurt <= 0 or not alive:
		return false
	BreathManager.max_breath -= hurt * HURT_PERCENT
	
	if BreathManager.max_breath == 0.0:
		SfxHelper.Play(ROAR_SOUND, self, 0.5)
		handle_death()
	else:
		SfxHelper.Play(ROAR_SOUND, self, randf_range(0.9, 1.1))
	
	return true

func handle_death():
	alive = false
	dragon = null
