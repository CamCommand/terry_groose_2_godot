extends Area2D

@export var Horse_Coin_Total: int
@export var coin_pos_x: int
@export var coin_pos_y: int
var coin_rng := RandomNumberGenerator.new()

var direction_x: float
var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_rng.randomize()
	var width = get_viewport().get_visible_rect().size[0]
	coin_pos_x = coin_rng.randi_range(300, width)
	coin_pos_y = -120 #coin_rng.randi_range(-100, 0)
	position = Vector2(coin_pos_x, coin_pos_y)
	
	speed = coin_rng.randi_range(350, 450)
	direction_x = coin_rng.randf_range(-1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta

func _on_button_pressed() -> void:
	Horse_Coin_Total += 1
	$Button.disabled = true
	$Button.visible = false
	print(Horse_Coin_Total)
	

func _on_body_entered(body: Node2D) -> void:
	pass
	#print("coin hit bottom")
	#$Button.visible = true
