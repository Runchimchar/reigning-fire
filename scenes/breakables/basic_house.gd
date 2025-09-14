extends Area2D

const COIN_AUDIO = preload("res://assets/sounds/coins.mp3")
const SPEAR = preload("res://scenes/projectiles/spear.tscn")

const BASE_POINTS: int = 210
const POINT_SKEW: float = BASE_POINTS * 0.2

# Every SPEAR_CHECK_RATE seconds, spear_chance is rolled.
const SPEAR_CHECK_RATE: float = 0.1
var spear_chance: float = 0.005

var broken: bool = false

func _ready():
	# Create a SPEAR_CHECK_RATE timer.
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(_spear_timer)
	timer.start(SPEAR_CHECK_RATE)

func _spear_timer():
	# Roll for spear.
	if Dragon.dragon != null and randf() <= spear_chance:
		var spear = SPEAR.instantiate()
		
		# Target *near* the player.
		const VARIANCE = 150
		var target: Vector2 = Dragon.dragon.global_position \
			+ Vector2(randf_range(-VARIANCE, VARIANCE), randf_range(-VARIANCE, VARIANCE))
		spear.rotation = global_position.angle_to_point(target)
		
		get_tree().root.add_child(spear)
		spear.global_position = global_position

# Required by group 'breakable', returns true if can break.
func _try_break() -> bool:
	SfxHelper.Play(COIN_AUDIO, get_tree().root, randf_range(0.9, 1.1))
	SfxHelper.Burst($Coins, get_tree().root)
	PointsManager.points += get_points()
	
	queue_free()
	return true

func get_points() -> int:
	return BASE_POINTS + round(randf_range(-POINT_SKEW, POINT_SKEW))

func _on_particles_finished():
	queue_free()
