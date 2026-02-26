extends Sprite2D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($".", "scale", Vector2(.1,.1), 0.5).from(Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta
	#print("oof")

# deletes +1 image
func _on_delete_one_timer_timeout() -> void:
	$"..".queue_free()
