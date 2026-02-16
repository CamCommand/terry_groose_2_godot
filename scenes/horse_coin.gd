extends Area2D

@export var Horse_Coin_Total: int
@export var coin_pos_x: int
@export var coin_pos_y: int
var coin_rng := RandomNumberGenerator.new()

var direction_x: float
var speed

@export var HorseCheck: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setting the coin location at top of screen with random x valye 
	coin_rng.randomize()
	var width = get_viewport().get_visible_rect().size[0]
	coin_pos_x = coin_rng.randi_range(300, width)
	coin_pos_y = -120 #coin_rng.randi_range(-100, 0)
	position = Vector2(coin_pos_x, coin_pos_y)
	# set coin speed and direction
	speed = coin_rng.randi_range(350, 450)
	direction_x = coin_rng.randf_range(-1, 1)
	# check if horse has been bought already
	#var horse = get_tree().get_first_node_in_group("horse_vars")
	#if HorseCheck == false:
		#horse.visible = false
	#else:
		#horse.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta

func _on_button_pressed() -> void:
		
	var horse = get_tree().get_first_node_in_group("horse_vars")
	if HorseCheck == false:
		HorseCheck = true
		horse.visible = true

	Horse_Coin_Total = 1 # not adding properly, it's their own instance of the variable
	# delete the coin
	$".".queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	$".".queue_free()
