extends Area2D

var direction_x: float
var speed
var roataion_speed: int

func _ready():	
	var sand_rng := RandomNumberGenerator.new()
	# textures: make more later
	var yellow: String = "res://graphics/Sands/yellow_sand" + str(sand_rng.randi_range(1, 2)) + ".png"
	var orange: String = "res://graphics/Sands/orange_sand" + str(sand_rng.randi_range(1, 2)) + ".png"
	var black: String = "res://graphics/Sands/black_sand" + str(sand_rng.randi_range(1, 2)) + ".png"
	var white: String = "res://graphics/Sands/white_sand" + str(sand_rng.randi_range(1, 2)) + ".png"
	
	#connect("body_entered", Callable(self, "_on_body_entered"))
	
	# randomly select texture
	var path: int = sand_rng.randi_range(1,4)	
	match path:
		1:
			$SandSprite.texture = load(yellow)
		2:
			$SandSprite.texture = load(orange)
		3:
			$SandSprite.texture = load(black)
		4:
			$SandSprite.texture = load(white)
			
	var size: float = sand_rng.randf_range(0.30, 0.65)#size of sand
	var width = get_viewport().get_visible_rect().size[0]#width of screen
	var random_x = sand_rng.randi_range(50, width-50)#spawning zones/position
	var random_y = sand_rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	speed = sand_rng.randi_range(200, 650)#
	roataion_speed = sand_rng.randi_range(40, 100)
	direction_x = sand_rng.randf_range(-1, 1)
	#print(size)
	$SandSprite.scale =  Vector2(size, size)
	
	# free after 5 seconds on-screen
	var free_timer = Timer.new()
	free_timer.wait_time = 5.0
	free_timer.one_shot = true
	add_child(free_timer)
	free_timer.connect("timeout", Callable(self, "_on_free_timeout"))
	free_timer.start()

func _process(delta):
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += roataion_speed * delta
	
func _on_body_entered(body) -> void:
	if body is CharacterBody2D:
		var managers = get_tree().get_nodes_in_group("sand_manager")
		if managers.size() > 0:
			managers[0].call_deferred("add_sand", 1)
		
	
func _on_free_timeout():
	queue_free()
	
