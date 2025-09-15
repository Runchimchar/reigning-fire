@tool
extends TextureRect

var gradient: Gradient

@export var original_gradient: Gradient
var time: float = 0

var alt_color_0: Color = Color.from_string("#fd6200", Color.MAGENTA)
var alt_color_1: Color = Color.from_string("#ffc71c", Color.MAGENTA)

# Called when the node enters the scene tree for the first time.
func _ready():
	gradient = (texture as GradientTexture2D).gradient
	original_gradient = gradient.duplicate(true)
	gradient.set_color(0, Color.CYAN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update time
	time = time + delta
	if time > 2*PI: 
		time -= 2*PI
	
	update_color(0, alt_color_0)
	update_color(1, alt_color_1)
	
func update_color(i, alt):
	var new_color = original_gradient.get_color(i).lerp(alt, get_lerp(time))
	gradient.set_color(i, new_color)
	
func get_lerp(t):
	var wave = -0.1*sin(t+4.3) + 1.3*sin(2*t+6.9) + 1.2*sin(3*t+0)
	return 0.21*wave+0.45
