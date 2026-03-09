extends Node2D

var summon_speed = 75
var move_speed = 50
@onready var golem_sfx: AudioStreamPlayer2D = $golemsfx
@onready var summon_sfx: AudioStreamPlayer2D = $summonsfx
var sfx_Check: bool = false
var float_rng := RandomNumberGenerator.new()
# golem rotation speed range
var rotation_golem = float_rng.randi_range(-8, 7) + 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(200, 850)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# moves golem up "summoning", then animated them walking off screen
# then in space they just float off
	var main = get_tree().get_first_node_in_group("main")
	if main.space_check == false:
		if position.y > 560:
			if sfx_Check == false:
				summon_sfx.play()
				sfx_Check = true
			position.y -= 2 * summon_speed * delta
		else:
			$GolemSprite.play()
			if sfx_Check == true:
				golem_sfx.play()
				sfx_Check = false
			position.x += -2 * move_speed * delta
	else:
		if sfx_Check == false:
			summon_sfx.play()
			sfx_Check = true
		position.y -= 200 * delta
		rotation += rotation_golem * delta
# deletes node on timer tick
func _on_delete_golem_timer_timeout() -> void:
	$".".queue_free()
