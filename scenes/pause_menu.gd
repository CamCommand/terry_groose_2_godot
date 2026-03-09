extends Control
@onready var options: bool = false

func _ready() -> void:
	$MarginContainer/VBoxContainer/ColorRect/ScrollContainer/RichTextLabel.bbcode_enabled = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
func pause():
	get_tree().paused = true
	visible = true

func resume():
	#$CanvasLayer.visible = false
	get_tree().paused = false
	visible = false

func remove_cons():
	if $MarginContainer.visible == false:
		$MarginContainer.visible = true
	else:
		$MarginContainer.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			remove_cons()
			resume()
		else:
			remove_cons()
			pause()
			

func _on_resume_btn_pressed() -> void:
	remove_cons()
	resume()
	
func _on_conversion_btn_pressed() -> void:
	add_super_text()
	remove_cons()

func _on_quit_press() -> void:
	#terry_vars.visible = false
	#get_tree().change_scene_to_file("res://scenes/conversion_menu.tscn")
	#options = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func add_super_text():
	#$MarginContainer/VBoxContainer/ColorRect/ScrollContainer/RichTextLabel.append_text("E = mc[super][font_size=12]2")
	pass
