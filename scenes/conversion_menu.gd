extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()
		get_tree().paused = false
		visible = false
		terry_vars.visible = true
		get_tree().change_scene_to_file("res://scenes/PauseMenu.tscn")
