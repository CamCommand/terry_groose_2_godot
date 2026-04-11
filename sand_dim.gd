extends Node2D

@export var gravity: float = 1200.0
@export var jump_impulse: float = 450.0
@export var left_impulse: float = 350.0
@export var right_impulse: float = 350.0
@export var floor_y: float = 460.0
@export var left_wall: float = -128
@export var right_wall: float = 1494
var velocity: float = 0.0


var speed
var roataion_speed: int
var sand_scene: PackedScene = load("res://scenes/final_sand.tscn")

@export var New_Sand_Total_Eaten: float
@export var New_Sand_Mult: float
@export var New_Sand_Counter: int = 1


func _ready():
	#var main = get_tree().get_first_node_in_group("main")
	#if $Sand_Ate.text != null:
		#$Sand_Ate.text = NumberFormatter.format_clicker_number(main.Sand_Total_Eaten, 1)
	#else:
		#$Sand_Ate.text = NumberFormatter.format_clicker_number(0, 1)
	pass	
# call this to add to the sand modifiers on screen
func add_sand(amount: int) -> void:
	New_Sand_Counter *= amount + New_Sand_Counter
	New_Sand_Mult += New_Sand_Counter
	$Sand_Mult.text = NumberFormatter.format_clicker_number(New_Sand_Mult, 3)
	#print(New_Sand_Mult)
	print(str(New_Sand_Mult))
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Float"):
		velocity = -jump_impulse
	if Input.is_action_just_pressed("left") or Input.is_action_pressed("left"):
		$CharacterBody2D.position.x -= left_impulse * delta 
	if Input.is_action_just_pressed("right") or Input.is_action_pressed("right"):
		$CharacterBody2D.position.x += right_impulse * delta 
	
	#gravity
	velocity += gravity * delta

	#position
	$CharacterBody2D.position.y += velocity * delta

	# clamp to floor after movement
	if $CharacterBody2D.position.y > floor_y:
		$CharacterBody2D.position.y = floor_y
		velocity = 0.0
		left_impulse = 0.0
		right_impulse = 0.0
	else:
		impluse_reset()
		
	#disable left and right movement on the floor so you can just slide
	if $CharacterBody2D.position.x < left_wall and not $CharacterBody2D.position.y > floor_y:
		left_impulse = 0.0
	if $CharacterBody2D.position.x > right_wall and not $CharacterBody2D.position.y > floor_y:
		right_impulse = 0.0
		

	#print(str($CharacterBody2D.position))
	#print(str(left_impulse))
func _on_sand_timer_timeout() -> void:
	var sandy = sand_scene.instantiate()
	add_child(sandy)
	
func impluse_reset():
	#reset impulses
	left_impulse = 350
	right_impulse = 350
