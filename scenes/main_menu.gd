extends Node2D

const SAVE_PATH = "user://savegame.json"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _ready() -> void:
	#if not FileAccess.file_exists("user://savegame.json"):
		#$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled = true
	#else:
		#$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled = false
	if not FileAccess.file_exists("user://SavedGame.tscn"):
		$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled = true
	else:
		$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled= false

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_load_game_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	#var new_scene = load("user://SavedGame.tscn")
	get_tree().change_scene_to_file("user://SavedGame.tscn")
	#get_tree().change_scene_to_file(new_scene)
	self.queue_free()
