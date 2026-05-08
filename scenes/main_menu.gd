extends Node2D

const SAVE_PATH = "user://savegame.json"
@onready var button_click_sfx: AudioStreamPlayer2D = $CanvasLayer/MarginContainer/VBoxContainer/ButtonClickSFX
@onready var button_hover_sfx: AudioStreamPlayer2D = $CanvasLayer/MarginContainer/VBoxContainer/ButtonHoverSFX
# Variables to control the breathing effect
var min_opacity: float = 0.5 
var max_opacity: float = 1.0  
var speed: float = 0.25       
var is_breathing: bool = false 
@onready var breathing_label: AnimatedSprite2D = $MarginContainer/HBoxContainer/NewFrontier

@onready var sand_fact_label = $SandFact
var sand_rng := RandomNumberGenerator.new()
var label: Label
var lines: Array = []

func _process(_delta: float) -> void:
	if is_breathing:
		var new_opacity = breathing_label.modulate.a + speed * _delta
		
		if new_opacity >= max_opacity:
			speed = -abs(speed)
		elif new_opacity <= min_opacity:
			speed = abs(speed)
			
		new_opacity = clamp(new_opacity, min_opacity, max_opacity)
		breathing_label.modulate.a = new_opacity
	
func _ready() -> void:
	load_lines("res://sandfacts.txt")
	display_sand_fact()
	
	if not FileAccess.file_exists("user://SavedGame.tscn"):
		$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled = true
	else:
		$CanvasLayer/MarginContainer/VBoxContainer/LoadGame.disabled= false
		
	#main menu Terry's hat color
	if Global.has_won_flag == true:
		$BKG1.visible = false
		$BKG2.visible = true
	else:
		$BKG1.visible = true
		$BKG2.visible = false
func _on_new_game_pressed() -> void:
	await play_sfx()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_load_game_pressed() -> void:
	button_click_sfx.play()	
	await play_sfx()
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	#var new_scene = load("user://SavedGame.tscn")
	#loads differently if you won already
	if Global.has_won_flag == true:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		Global.has_won_flag = false
	else:
		get_tree().change_scene_to_file("user://SavedGame.tscn")
	#get_tree().change_scene_to_file(new_scene)
	self.queue_free()

func _on_credit_pressed() -> void:
	await play_sfx()
	OS.shell_open("https://camcommand.itch.io")
	
func play_sfx():
	button_click_sfx.play()	
	await get_tree().create_timer(.20).timeout

func load_lines(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			lines.append(line)  # Store each line in the array
		
		file.close()
	else:
		pass
	
func display_sand_fact():
	sand_rng.randomize()
	if lines.size() > 1:
		var random_index = sand_rng.randi() % lines.size()  # Get a random index
		if random_index != 66:
			sand_fact_label.text = "Sand Fact! \n" + lines[random_index]  # Set the label text to the random line	
			$DustBaby.visible = false
		else:
			@warning_ignore("standalone_expression")
			sand_fact_label.text + " "
			$DustBaby.visible = true
	else:
		if OS.has_feature("standalone"):
			sand_fact_label.text = "Sand Fact! \nDeleting me will not stop what is to come."
		else:
			sand_fact_label.text = "Sand Facts! \nCome with the full version, sorry, download me please, thank you..."

func _hover_play():
	button_hover_sfx.play()

func _on_new_game_mouse_entered() -> void:
	_hover_play()

func _on_load_game_mouse_entered() -> void:
	_hover_play()

func _on_quit_game_mouse_entered() -> void:
	_hover_play()

func _on_credit_mouse_entered() -> void:
	_hover_play()
