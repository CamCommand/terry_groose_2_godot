extends Node2D
@onready var terry: AnimatedSprite2D = $AnimatedSprite2D
var moving := false
var should_stop := false

var dumb_terry_check: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terry.animation_finished.connect(_on_animation_finished)
	if is_instance_valid(terry_vars) && dumb_terry_check == false:
		self.visible = false
		dumb_terry_check = true
	
func set_moving(is_moving: bool) -> void:
	if is_moving:
		if not terry.is_playing():
			terry.play()
	else:
		await terry.animation_finished
		terry.stop()
		terry.frame = 0

func _on_animation_finished():
	if should_stop:
		terry.stop()
		terry.frame = 0
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if dumb_terry_check == true:
		#self.visible = true
	pass
