extends Area2D

@export var Horse_Coin_Total: int
@export var coin_pos_x: int
@export var coin_pos_y: int
var coin_rng := RandomNumberGenerator.new()

var direction_x: float
var speed

@export var HorseCheck: bool
@export var Horse_Sand_Eat: int
@export var popup_one: PackedScene = load("res://scenes/+1.tscn")
@export var one_pos_x: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setting the coin location at top of screen with random x valye 
	coin_rng.randomize()
	var width = get_viewport().get_visible_rect().size[0]
	coin_pos_x = coin_rng.randi_range(300, width-300)
	coin_pos_y = -120 #coin_rng.randi_range(-100, 0)
	position = Vector2(coin_pos_x, coin_pos_y)
	# set coin speed and direction
	speed = coin_rng.randi_range(350, 650)
	direction_x = coin_rng.randf_range(-0.3, 0.3)

# speed and direction of horse coin
func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta
	
#when Horse Coin is clicked
func _on_button_pressed() -> void:
	var main = get_tree().get_first_node_in_group("main")
	var horse = get_tree().get_first_node_in_group("horse_vars") as AnimatedSprite2D
	#play sfx DOESN'T WORK
	#currently plays when added to the scene
	#$CoinSFX.play()
	
	if HorseCheck == false:
		HorseCheck = true
		horse.visible = true
		# moves in the horse
		var horse_tween := create_tween().bind_node(horse).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		horse_tween.tween_property(horse, "position", Vector2(300, 392), 0.5)#.from(Vector2(0,0))
	if main:
		if main.Horse_Sand_Eat == 0:
			main.Horse_Sand_Eat = 1
		else:
			# adds +1 image when horse upgrades, randomizes position_x value 
			coin_rng.randomize()
			one_pos_x = coin_rng.randi_range(275, 320)
			var instance = popup_one.instantiate()
			instance.global_position = Vector2(one_pos_x, 400)
			main.add_child(instance)
			
			main.Horse_Sand_Eat *= 2
	#deletes coin
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	$".".queue_free()


#func _on_p_one(pos: Variant) -> void:
	#var one = PlusOne_scene.instantiate()
	#$"+1".add_child(one)
	#one.position = pos
