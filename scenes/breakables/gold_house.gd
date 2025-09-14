extends Area2D

const COIN_AUDIO = preload("res://assets/sounds/big_coins.wav")

const BASE_POINTS: int = 810
const POINT_SKEW: float = BASE_POINTS * 0.2

var broken: bool = false

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
