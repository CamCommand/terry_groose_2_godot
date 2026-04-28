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
@onready var sand_ate: RichTextLabel = $Sand_Ate
@export var sand_ate_growth: float = 1

@export var New_Sand_Total_Eaten: float
@export var New_Sand_Mult: float = 1
@export var New_Sand_Counter: int = 1
@export var Sand_Dim_Sand_Eat: float = 1
var Timer_dif_counter: int = 0

@onready var terry: CharacterBody2D = $Terry
@onready var terry_final: AnimatedSprite2D = $Terry_Final

var step_tween: Tween = null
const STEPS := 9
const STEP_AMOUNT := 1.0 / STEPS
const STEP_DURATION := 0.15

@onready var hat_fan_fare_1: AudioStreamPlayer2D = $HatFanFare1
@onready var hat_fan_fare_2: AudioStreamPlayer2D = $HatFanFare2
var direction_var: PackedScene = load("res://scenes/sand_dim_directions.tscn")

func _ready():
	#spawn directions
	var directions = direction_var.instantiate()
	directions.global_position.x = 650
	directions.global_position.y = 300
	add_child(directions)
	
	$SandTimer.wait_time = 1.0
	New_Sand_Total_Eaten = Global.Sand_Total_Eaten
	if New_Sand_Total_Eaten == 0: New_Sand_Total_Eaten += 1
	$Sand_Ate.text = NumberFormatter.format_clicker_number(New_Sand_Total_Eaten, 6)
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
	if amount == 0: amount = 1
	Sand_Dim_Sand_Eat *= multiply
	New_Sand_Total_Eaten += Sand_Dim_Sand_Eat
	#print(str(New_Sand_Mult))
	
	#label_animation($Sand_Ate, adding_animation_value, New_Sand_Total_Eaten, 0.025)
	$Sand_Ate.text = NumberFormatter.format_clicker_number(New_Sand_Total_Eaten, 6)
	#speeds up sand spawning the more you get
	if str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 5 and Timer_dif_counter == 0:#.9 seconds
		_next_sand_advance()
		#print("hit")
		#print(str(snapped(New_Sand_Total_Eaten, 0.01)).length())
		#print(str($SandTimer.wait_time))
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 25 and Timer_dif_counter == 1:#.8 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 40 and Timer_dif_counter == 2:#.7 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 80 and Timer_dif_counter == 3:#0.6 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 95 and Timer_dif_counter == 4:#0.5 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 110 and Timer_dif_counter == 5:#0.4 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 130 and Timer_dif_counter == 6:#0.3 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 140 and Timer_dif_counter == 7:#0.2 seconds
		_next_sand_advance()
	elif str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 155 and Timer_dif_counter == 8:#0.1 seconds
		_next_sand_advance()
	else:
		pass
	#print(str($SandTimer.wait_time))
func _next_sand_advance():
	#increases the amount of sand that spawns
	Timer_dif_counter += 1
	if Timer_dif_counter != 8:
		$SandTimer.wait_time = max(0.1, $SandTimer.wait_time - 0.1)
	else:
		$SandTimer.wait_time = 0.1
	#print(str($SandTimer.wait_time))
	#makes the hat button arrive slowly
	var current = $HatButton.self_modulate.a
	if current >= 1.0:
		return
	var target = min(1.0, current + STEP_AMOUNT)

	if step_tween:
		step_tween.kill()
		step_tween = null

	step_tween = create_tween()
	step_tween.tween_property($HatButton, "self_modulate:a", target, STEP_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	step_tween.connect("finished", Callable(self, "_on_step_tween_finished"))

func _on_step_tween_finished():
	step_tween = null
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Float"):
		velocity = -jump_impulse
	if Input.is_action_just_pressed("left") or Input.is_action_pressed("left"):
		terry.position.x -= left_impulse * delta 
		$Terry/AnimatedSprite2D.flip_h = true
	if Input.is_action_just_pressed("right") or Input.is_action_pressed("right"):
		terry.position.x += right_impulse * delta 
		$Terry/AnimatedSprite2D.flip_h = false
	#gravity
	velocity += gravity * delta
	#position
	terry.position.y += velocity * delta

	# clamp to floor after falling down
	if terry.position.y > floor_y:
		terry.position.y = floor_y
		velocity = 0.0
		left_impulse = 0.0
		right_impulse = 0.0
	else:
		impluse_reset()
		
	#disable left and right movement on the floor so you can just slide
	if terry.position.x < left_wall and not terry.position.y > floor_y:
		left_impulse = 0.0
	if terry.position.x > right_wall and not terry.position.y > floor_y:
		right_impulse = 0.0
		
	#print(str(terry.position))
	#print(str(left_impulse))
func _on_sand_timer_timeout() -> void:
	var sandy = sand_scene.instantiate()
	$Bottom.add_child(sandy)
	
func impluse_reset():
	#reset impulses
	left_impulse = 350
	right_impulse = 350

func _on_button_pressed() -> void:
	_next_sand_advance()

func _on_label_grow_timer_timeout() -> void:
	var tween = create_tween()
	sand_ate_growth += 0.005
	tween.tween_property(sand_ate, "scale", Vector2(sand_ate_growth,sand_ate_growth), 0.5)
 
func _on_hat_button_pressed() -> void:
	$ButtonClickSFX.play()
	$PauseMenu.queue_free()#get rid of pause menu
	var tween = create_tween()
	#removes all lingering sand from screen
	var parent = $Bottom
	for area in parent.get_children():
		if area is Area2D:
			parent.remove_child(area)
			area.queue_free()
	#stop the game
	$HatTimer.stop()
	$LabelGrowTimer.stop()
	$SandTimer.stop()
	$auto_save_Timer.stop()
	$HatButton.visible = false
	$Terry.visible = false
	sand_ate.visible = false
	#final animations
	tween.tween_property(terry_final, "self_modulate:a", 1, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(2).timeout
	hat_fan_fare_1.play()
	terry_final.frame = 1
	await get_tree().create_timer(1.5).timeout
	hat_fan_fare_2.play()
	terry_final.frame = 2
	$"Thank U".visible = true
	await get_tree().create_timer(5.5).timeout
	Global.has_won_flag = true
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_hat_timer_timeout() -> void:
	print(str(snapped(New_Sand_Total_Eaten, 0.01)).length())
	#when the button unlock !!!
	if str(snapped(New_Sand_Total_Eaten, 0.01)).length() >= 160:
		$HatButton.disabled = false
		$HatButton.text = "Buy A New" + "\n" + "Hat" + "\n" + "∞"
		$HatButton.modulate = Color(0.0, 0.775, 0.351, 1.0)
		
func _on_auto_save_timer_timeout() -> void:
	var root = get_tree().current_scene
	var scene = PackedScene.new()
	scene.pack(root)
	ResourceSaver.save(scene, "user://SavedGame.tscn")

func _on_button_mouse_entered() -> void:
	$ButtonHoverSFX.play()
