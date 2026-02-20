extends Area2D

@export var Horse_Coin_Total: int
@export var coin_pos_x: int
@export var coin_pos_y: int
var coin_rng := RandomNumberGenerator.new()

var direction_x: float
var speed

@export var HorseCheck: bool
@export var Horse_Sand_Eat: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setting the coin location at top of screen with random x valye 
	coin_rng.randomize()
	var width = get_viewport().get_visible_rect().size[0]
	coin_pos_x = coin_rng.randi_range(300, width-300)
	coin_pos_y = -120 #coin_rng.randi_range(-100, 0)
	position = Vector2(coin_pos_x, coin_pos_y)
	# set coin speed and direction
	speed = coin_rng.randi_range(350, 450)
	direction_x = coin_rng.randf_range(-0.3, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta

func _on_button_pressed() -> void:
	var main = get_tree().get_first_node_in_group("main")
	var horse = get_tree().get_first_node_in_group("horse_vars")
	if HorseCheck == false:
		HorseCheck = true
		horse.visible = true
	if main:
		if main.Horse_Sand_Eat == 0:
			main.Horse_Sand_Eat = 1
		else:
			main.Horse_Sand_Eat *= 2
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	$".".queue_free()
