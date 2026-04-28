extends AnimatedSprite2D

@onready var btn = $WhaleClickerButton
@onready var sprite = $"."
@onready var sand = $SandCPUParticles2D
var bursts = 80                # number of bursts per press
var burst_interval = 0.15     # seconds between bursts
var burst_random = 0.55       # random jitter on interval
var burst_move = true         # reposition emitter each burst
var emitter_offset = Vector2(0, 40) # local offset under sprite

func _ready():
	btn.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	play_bursts(bursts)

func play_bursts(count: int) -> void:
	# read particle properties once
	var particle_life: float = float(sand.lifetime)
	var life_rand: float = 0.0
	if sand is CPUParticles2D:
		life_rand = float(sand.lifetime_randomness)

	var max_particle_life: float = particle_life * (1.0 + life_rand)
	# for not overlapping sequences of sand falling
	for i in range(count):
		if burst_move:
			var jitter_x: int = randi_range(-12, 12)
			sand.position = emitter_offset + Vector2(jitter_x, 155)

		sand.one_shot = true
		sand.emitting = true

		var wait_time: float = max(0.01, max_particle_life)
		await get_tree().create_timer(wait_time).timeout
		
# helpers for maximum randomness
func randi_range(a: int, b: int) -> int:
	return randi() % (b - a + 1) + a

func randf_range(a: float, b: float) -> float:
	return randf() * (b - a) + a
