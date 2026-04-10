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

func _ready():
	pass
		
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
