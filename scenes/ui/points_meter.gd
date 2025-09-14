extends Control

func _ready():
	PointsManager.points_updated.connect(_on_points_updated)

func _process(delta):
	pass

func _on_points_updated(points: int):
	$Label.text = "%d" % points
