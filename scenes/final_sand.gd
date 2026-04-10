extends Area2D

var direction_x: float
var speed
var roataion_speed: int

func _ready():
	
	var rock_rng := RandomNumberGenerator.new()

	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rock_rng.randi_range(50, width-50)
	var random_y = rock_rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	speed = rock_rng.randi_range(300, 500)
	roataion_speed = rock_rng.randi_range(40, 100)
	direction_x = rock_rng.randf_range(-1, 1)

func _process(delta):
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += roataion_speed * delta
	
func _on_body_entered(_body) -> void:
	#print("collision")
	pass
