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
@export var New_Sand_Mult: float = 1
@export var New_Sand_Counter: int = 1
@export var Sand_Dim_Sand_Eat: float = 1
var Timer_dif_counter: int = 0

func _ready():
	$SandTimer.wait_time = 1.0
	New_Sand_Total_Eaten = Global.Sand_Total_Eaten
	if New_Sand_Total_Eaten == 0: New_Sand_Total_Eaten += 1
	$Sand_Ate.text = NumberFormatter.format_clicker_number(New_Sand_Total_Eaten, 1)
# call this to add to the sand modifiers on screen
	#await label_animation($Test, 1, 200, 0.0001)

func label_animation(label: Label, start:float, end:float, duration:float) -> void:
	var steps = abs(end - start)
	if steps == 0:
		label.text = str(end)
		return
	var step_time = duration / float(steps)
	var dir = 1 if end > start else -1
	var value = start
	for i in range(steps):
		value += dir
		label.text = str(value)
		if end >= 0:
			label.text += str(end)
		else:
			label.text += "%"
		await get_tree().create_timer(step_time).timeout
		#"Sand Ate: " + "%.2f%s" % [abs_value, suffixes[index]] + " oz"	
	
func add_sand(amount: int) -> void:#currently not using sand_mult
	var sand_rng2 := RandomNumberGenerator.new()
	var multiply: float = sand_rng2.randf_range(1.1, 3.0)#random multipler bc I can't decide
	#amount is always increments 1 
	#var adding_animation_value = New_Sand_Total_Eaten
	#var New_Sand_Value_test = New_Sand_Mult
	#var New_Sand_Eat_test = Sand_Dim_Sand_Eat
	if amount == 0: amount = 1
	Sand_Dim_Sand_Eat *= multiply
	New_Sand_Total_Eaten += Sand_Dim_Sand_Eat
	#Sand_Dim_Sand_Eat *= amount
	#New_Sand_Total_Eaten += Sand_Dim_Sand_Eat
	#when there is an overflow, fix the value roughly
	#below works just not using anymore
	#if New_Sand_Mult < New_Sand_Value_test or Sand_Dim_Sand_Eat < New_Sand_Eat_test:
		#New_Sand_Mult = abs(New_Sand_Value_test) * 2
		#Sand_Dim_Sand_Eat = abs(New_Sand_Eat_test) * 2
		#New_Sand_Total_Eaten += Sand_Dim_Sand_Eat
	#else:
		#New_Sand_Total_Eaten += Sand_Dim_Sand_Eat
		
	#print("Mult " + str(multiply) + " Total " + str(New_Sand_Total_Eaten))
	#print(str(New_Sand_Mult))
	
	#label_animation($Sand_Ate, adding_animation_value, New_Sand_Total_Eaten, 0.025)
	$Sand_Ate.text = NumberFormatter.format_clicker_number(New_Sand_Total_Eaten, 1)
	#$Sand_Mult.text = NumberFormatter.format_clicker_number(New_Sand_Mult, 3)
	#print(str(New_Sand_Mult))
	#New_Sand_Mult = New_Sand_Mult + amount
	#print(str(snapped(New_Sand_Total_Eaten, 0.01)))
	#speeds up sand spawning the more you get
	if str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 5 and Timer_dif_counter == 0:#.9 seconds
		_next_sand_advance()
		#print("hit")
		#print(str(snapped(New_Sand_Total_Eaten, 0.01)).length())
		#print(str($SandTimer.wait_time))
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 10 and Timer_dif_counter == 1:#.8 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 15 and Timer_dif_counter == 2:#.7 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 16 and Timer_dif_counter == 3:#0.6 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 18 and Timer_dif_counter == 4:#0.5 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 20 and Timer_dif_counter == 5:#0.4 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 23 and Timer_dif_counter == 6:#0.3 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 27 and Timer_dif_counter == 7:#0.2 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 40 and Timer_dif_counter == 7:#0.1 seconds
		_next_sand_advance()
	#print(str($SandTimer.wait_time))
func _next_sand_advance():
	Timer_dif_counter += 1
	$SandTimer.wait_time -= 0.1
	
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

	# clamp to floor after falling down
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
	$Bottom.add_child(sandy)
	
func impluse_reset():
	#reset impulses
	left_impulse = 350
	right_impulse = 350
