extends Node2D

const BASIC_HOUSE = preload("res://scenes/breakables/basic_house.tscn")
const GOLD_HOUSE = preload("res://scenes/breakables/gold_house.tscn")

const SPEAR_CHANCE_INCR: float = 0.0001
const BASE_SPEAR_CHANCE: float = 0.005
const MAX_SPEAR_CHANCE: float = 0.02

const HOUSE_EDGE_PADDING: int = 100
const HOUSE_SPEED: int = 200
const MAX_SPREAD: int = 30
const MIN_SPREAD: int = -10

var house_bag = [BASIC_HOUSE, BASIC_HOUSE, BASIC_HOUSE, BASIC_HOUSE, GOLD_HOUSE]
var houses: Array[Area2D]
var next_spread: int
var next_house: Node2D
var spear_chance: float = BASE_SPEAR_CHANCE

func _ready():
	# Add initial house.
	ready_house()
	houses.append(next_house)
	next_house = null
	
	# Get inital spread.
	next_spread = randi_range(MIN_SPREAD, MAX_SPREAD)

func _process(delta):
	# Should we make a house?
	try_add_house()
	
	# Process houses.
	for node: Node2D in houses:
		# Handle old houses
		if node.global_position.x + HOUSE_EDGE_PADDING <= 0:
			houses.erase(node)
			node.queue_free()
			continue
			
		# Move house.
		node.position.x -= HOUSE_SPEED * delta

func ready_house():
	if next_house != null:
		push_error("Readied a house before the previous was handled.")
	
	var house = house_bag.pick_random().instantiate()
	house.tree_exiting.connect(func(): houses.erase(house))
	
	# Set the spear_chance, if it has one.
	if house.get("spear_chance") != null:
		house.spear_chance = spear_chance
		spear_chance = min(spear_chance + SPEAR_CHANCE_INCR, MAX_SPEAR_CHANCE)
	
	add_child(house)
	next_house = house

# Lazy load these vars.
var prev_coll_shape: CollisionShape2D
var next_coll_shape: CollisionShape2D
func try_add_house():
	# Ready a house if one isn't readied.
	if next_house == null:
		ready_house()
	
	# Lazy load these children.
	if prev_coll_shape == null: prev_coll_shape = houses[-1].find_child("CollisionShape2D")
	if next_coll_shape == null: next_coll_shape = next_house.find_child("CollisionShape2D")
	
	# Check if we can add the next house.
	var prev_right = prev_coll_shape.shape.get_rect().end.x \
		* prev_coll_shape.global_scale.x \
		+ prev_coll_shape.global_position.x
	var next_left = next_coll_shape.shape.get_rect().position.x \
		* next_coll_shape.global_scale.x \
		+ next_coll_shape.global_position.x
	
	if next_left - prev_right >= next_spread:
		# Add the house.
		houses.append(next_house)
		# Reset variables.
		next_spread = randi_range(MIN_SPREAD, MAX_SPREAD)
		next_house = null
		prev_coll_shape = null
		next_coll_shape = null
