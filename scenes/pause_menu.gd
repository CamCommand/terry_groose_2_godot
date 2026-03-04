extends Control
@onready var options: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func pause():
	get_tree().paused = true
	visible = true

func resume():
	#$CanvasLayer.visible = false
	get_tree().paused = false
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			#$CanvasLayer.visible = true
			pause()
			

func _on_resume_btn_pressed() -> void:
	resume()
	
func _on_abv_pressed() -> void:
	#terry_vars.visible = false
	#get_tree().change_scene_to_file("res://scenes/conversion_menu.tscn")
	#options = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
