extends Node2D

var summon_speed = 75
var move_speed = 50
@onready var golem_sfx: AudioStreamPlayer2D = $golemsfx
@onready var summon_sfx: AudioStreamPlayer2D = $summonsfx
var sfx_Check: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(200, 850)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# moves golem up "summoning", then animated them walking off screen
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
# deletes node on timer tick
func _on_delete_golem_timer_timeout() -> void:
	$".".queue_free()
