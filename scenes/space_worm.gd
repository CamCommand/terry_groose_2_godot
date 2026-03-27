extends Area2D


@export var worm_total: int
@export var worm_pos_x: int
@export var worm_pos_y: int
var worm_rng := RandomNumberGenerator.new()

var direction_x: float
var speed

@export var WormCheck: bool
@export var Worm_Sand: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setting the worm location at right of screen with random x valye 
	worm_rng.randomize()
	worm_pos_y = worm_rng.randi_range(160, 560)
	worm_pos_x = 1990
	position = Vector2(worm_pos_x, worm_pos_y)
	
	# set worm speed and direction
	speed = worm_rng.randi_range(450, 650)
	direction_x = worm_rng.randf_range(-0.3, 0.3)
	
	await get_tree().create_timer(5.0).timeout
	queue_free()

# speed and direction of worm
func _process(delta: float) -> void:
	position -= Vector2(1, 0.1) * speed * delta
	#print(str(position))
	
#when Worm is clicked
func _on_button_pressed() -> void:
	var main = get_tree().get_first_node_in_group("main")
	#var horse = get_tree().get_first_node_in_group("horse_vars") as AnimatedSprite2D
	print("Worm hit")
	if main:	
		main.Sand_Total_Eaten += main.Worm_Sand_Eat
		main.Space_Sand += main.Worm_Sand_Eat
	#deletes worm
	queue_free()	
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		_on_button_pressed()
