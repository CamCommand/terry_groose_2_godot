extends Node2D
@export var shrimp_pos_x: int
@export var shrimp_pos_y: int
var rng := RandomNumberGenerator.new()
var rotation_speed_shrimp
@onready var shrimp_audio: AudioStreamPlayer2D = $ShrimpAudio
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# shrimps
	shrimp_pos_x = rng.randi_range(350, 1300)
	shrimp_pos_y = rng.randi_range(60, 150)
	position = Vector2(shrimp_pos_x, shrimp_pos_y)
	$".".global_position = Vector2(shrimp_pos_x, shrimp_pos_y)
		
	# scale
	var random_scale = rng.randf_range(.5,1)
	$".".global_scale = Vector2(random_scale, random_scale)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#makes the shrimp kind of wiggle, which is funny
	rotation_speed_shrimp = rng.randf_range(-12.0, 12.0)
	$"SpaceShrimpSprite-yo".rotation_degrees += rotation_speed_shrimp * delta
	#var rotation_speed_shrimp_rand = rng.randi_range(0, 1)
	#if rotation_speed_shrimp_rand == 0:
		#$"SpaceShrimpSprite-yo".rotation_degrees += -12 * delta
	#else:
		#$"SpaceShrimpSprite-yo".rotation_degrees += 12 * delta
		
func play_shrimp_sfx():
	shrimp_audio.play()
