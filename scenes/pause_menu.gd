extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func pause():
	get_tree().paused = true
	visible = true

func resume():
	get_tree().paused = false
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_btn_pressed() -> void:
	resume()
	
#func _on_options_pressed():
	#resume()
	#get_tree().change_scene_to_file("res://conversion_menu.tscn")
