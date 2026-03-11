@tool
extends Node2D

@export var Sand: float = 1
@export var Sand_Total: float 
@export var Sand_Total_Eaten: float 
@export var Space_Sand: float
@export var Space_Sand_Mult: float
var test = 0

var next_input: bool = false
@export var s_label: String
@export var s_label_d: String
@onready var button_click_sfx: AudioStreamPlayer2D = $ScrollContainer/VBoxContainer/ButtonClickSFX
@onready var terry_play = $terry
var coin_scene: PackedScene = load("res://scenes/horse_coin.tscn")
var golem_scene: PackedScene = load("res://scenes/golem_2d.tscn")

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool
@onready var spoon_audio: AudioStreamPlayer2D = $SpoonAudio

@export var TrowlUpgradeCost: float = 1000
@export var TrowlCounter: float
@export var TrowlCheck: bool
@export var SuperTrowlCheck: bool
@onready var trowl_audio: AudioStreamPlayer2D = $TrowlAudio

@export var PanUpgradeCost: float = 3000
@export var PanCounter: float
@export var PanCheck: bool
@export var SuperPanCheck: bool
@onready var pan_audio: AudioStreamPlayer2D = $PanAudio

@export var ShovelUpgradeCost: float = 10000
@export var ShovelCounter: float
@export var ShovelCheck: bool
@export var SuperShovelCheck: bool
@onready var shovel_audio: AudioStreamPlayer2D = $ShovelAudio

@export var CLSUpgradeCost: float = 100000
@export var CLSCounter: float
@export var CLSCheck: bool
@export var FCLSCheck: bool
@onready var cspoon_audio: AudioStreamPlayer2D = $CSpoonAudio

@export var DozerUpgradeCost: float = 1000000
@export var DozerCounter: float
@export var DozerCheck: bool
@export var BiggerDozerCheck: bool
@onready var dozer_audio: AudioStreamPlayer2D = $DozerAudio

@export var GolemUpgradeCost: float = 35000000
@export var GolemCounter: float
@export var GolemCheck: bool
@export var HelperGolemCheck: bool #have golems start automatically eating sand
#@onready var Golum_audio: AudioStreamPlayer2D = $GolumAudio

@export var SpaceCatUpgradeCost: float = 1
@export var SpaceCatCounter: int
@export var SpaceCatCheck: bool
const QTE = preload("res://scenes/QTE_Letter.tscn")
var QTE_var = preload("res://scenes/QTE_Letter.tscn")
var qte1 = QTE_var.instantiate()

@export var SC_Check_Min: float = 3.0
@export var SC_Check_Max: float = 10.0

var keyList = [
	{"keyString": "C", "keyCode": KEY_C},
	{"keyString": "O", "keyCode": KEY_O},
	{"keyString": "R", "keyCode": KEY_R},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "T", "keyCode": KEY_T},
	{"keyString": "A", "keyCode": KEY_A},
]
var music_list = []
var current_music_index = 0
@onready var music_player: AudioStreamPlayer = $Music2

var key_count = 0
var keyPressedList = []

@export var listItems: Array = []
@export var Coin_Spawn_Time: float 

@export var Horse_Sand_Eat: int
@export var HorseCheck: bool = false

@export var space_check: bool = false
var float_time := 0.0
var float_amplitude := 8.0
var float_speed := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#makes format_clicker_number not scream in error log
	$terry.visible = true
	if Engine.is_editor_hint():
		return
	if not FileAccess.file_exists("user://SavedGame.tscn"):	
		Sand_Total = 0
		Sand_Total_Eaten = 0

	var dir = DirAccess.open("user://")
	if not dir.dir_exists("music"):
		dir.make_dir("music")
		
	# Initialize the MusicManager with the AudioStreamPlayer
	MusicManager.init(music_player)
	
	#speed = float_rng.randi_range(1, 5)
	#roataion_speed = float_rng.randi_range(5, 10)
	#direction_x = float_rng.randf_range(0, 1)
	start_timers()

	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
	
func create_music_folder():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("music"):
		dir.make_dir("music")

	
func float_named_sprites(delta: float) -> void:
	float_time += delta
	var float_rng := RandomNumberGenerator.new()
	float_rng.randomize()

	for node in get_children():
		if node is AnimatedSprite2D and node.name.ends_with("Sprite"):

			# Assign a unique rotation speed once to each
			if not node.has_meta("rotation_speed"):
				node.set_meta("rotation_speed", float_rng.randf_range(-12.0, 12.0))  # random float speed left or right
			
			# Assign a unique float amplitude once (height)
			if not node.has_meta("float_amplitude"):
				node.set_meta("float_amplitude", float_rng.randf_range(5.0, 30.0))  # pixels
				
			var rotation_speed = node.get_meta("rotation_speed")

			# Apply rotation
			node.rotation_degrees += rotation_speed * delta

			# Store original Y once
			if not node.has_meta("base_y"):
				node.set_meta("base_y", node.position.y)
			
			var base_y = node.get_meta("base_y")
			node.position.y = base_y + sin(float_time * float_speed) * float_amplitude
			
		elif node is AnimatedSprite2D and node.name.ends_with("-o"):
			# float amplitude
			if not node.has_meta("float_amplitude"):
				node.set_meta("float_amplitude", 10)  # pixels
				
			# Store original Y once
			if not node.has_meta("base_y"):
				node.set_meta("base_y", node.position.y)
			
			var base_y = node.get_meta("base_y")
			node.position.y = base_y + sin(float_time * float_speed) * float_amplitude
	
func auto_input():
	if next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Input.action_press("ui_left")
		next_input = true
	else:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Input.action_press("ui_right")
		next_input = false

		
func _process(delta: float) -> void:
	#makes format_clicker_number not scream in error log	
	if Engine.is_editor_hint():
		return
		
	if space_check == true:
		float_named_sprites(delta)
	
	var moving := Input.is_action_pressed("ui_left") \
	or Input.is_action_pressed("ui_right")
	
	if terry_play:
		terry_play.set_moving(moving)
		
	if $Sand_Ate.text == "":
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		#$Sand_Ate.text = format_clicker_number(Sand_Total_Eaten, 1)
	if $Sand_Dollar.text == "":
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
	# dev cheat
	auto_input()
	
	if  Input.is_action_just_pressed("ui_left") && next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		next_input = true
	
	if Input.is_action_just_pressed("ui_right") && next_input == true:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		next_input = false
			
func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	if Sand_Total >= 100 && !listItems.has("Spoon"):
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Buy Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = false
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 100 && !listItems.has("Spoon"):
		#$SpoonButton.disabled = true
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = true
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost:
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = false
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost:
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = true
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = false
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && SpoonCounter == 11:
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = true
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
			
	elif SuperSpoonCheck == true && SpoonCounter == 14:
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Max Spoonage" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/SpoonButton.disabled = true
		$ScrollContainer/VBoxContainer/SpoonButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_spoon_button_pressed() -> void:
	#$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if SpoonCheck == false && SuperSpoonCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter < 11:
		Sand_Total -= SpoonUpgradeCost
		SpoonCounter += 1
		
	#multiplyer for bigger upgrades
		if SpoonCounter == 11:
			SpoonUpgradeCost = SpoonUpgradeCost * 2.5
			$ScrollContainer/VBoxContainer/SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		else:
			SpoonUpgradeCost = SpoonUpgradeCost + (100 * SpoonCounter)
			$ScrollContainer/VBoxContainer/SpoonButton.text = "Upgrade Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.1
		
	elif SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		#adding SuperSpoon
		listItems.append("Super Spoon")		
		SuperSpoonCheck = true
		SpoonCheck = false	
		$SpoonSprite.frame = 2
		
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.3
		SpoonUpgradeCost = SpoonUpgradeCost + (400 * SpoonCounter)
		SpoonCounter += 1
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
	
	elif SuperSpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter > 11:
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.35
		SpoonUpgradeCost = SpoonUpgradeCost + (400 * SpoonCounter)
		SpoonCounter += 1
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)

	if Sand_Total >= 100 && SpoonCheck == false && SuperSpoonCheck == false:
		Sand_Total -= 100
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Spoon")
		SpoonCheck = true
		
		#spawn SpoonSprite
		$SpoonSprite.visible = true
		var spoon_tween := create_tween().bind_node($SpoonSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		spoon_tween.tween_property($SpoonSprite, "position", Vector2(512, 700), 0.2)#.from(Vector2(0,0))
		spoon_audio.play()
		
		# update text with list of items here
		Sand = Sand * 1.1
		SpoonUpgradeCost = 200
		SpoonCounter += 1
		$ScrollContainer/VBoxContainer/SpoonButton.text = "Upgrade Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
	
func _on_trowl_timer_timeout() -> void:
# checking and setting Trowl Button conditions
	if Sand_Total >= 1000 && !listItems.has("Trowl"):
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Buy Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = false
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 1000 && !listItems.has("Trowl"):
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = true
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost:
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = false
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost:
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = true
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = false
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost && TrowlCounter == 11:
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperTrowlCheck == true && TrowlCounter == 16:
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Max Trowl" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/TrowlButton.disabled = true
		$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_trowl_button_pressed() -> void:
	#$ScrollContainer/VBoxContainer/TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if TrowlCheck == false && SuperTrowlCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter < 11:
		Sand_Total -= TrowlUpgradeCost
		TrowlCounter += 1
		
	#multiplyer for bigger upgrades
		if TrowlCounter == 11:
			TrowlUpgradeCost = TrowlUpgradeCost * 2.5
			$ScrollContainer/VBoxContainer/TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		else:
			TrowlUpgradeCost = TrowlUpgradeCost + (150 * TrowlCounter)
			$ScrollContainer/VBoxContainer/TrowlButton.text = "Upgrade Trowl " +"\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.2
		
	elif TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		listItems.append("Super Trowl")		
		SuperTrowlCheck = true
		TrowlCheck = false	
		$TrowlSprite.frame = 2
		
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.4
		TrowlUpgradeCost = TrowlUpgradeCost + (800 * TrowlCounter)
		TrowlCounter += 1
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
	
	elif SuperTrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter > 11:
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.25
		TrowlUpgradeCost = TrowlUpgradeCost + (800 * TrowlCounter)
		TrowlCounter += 1
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)

	if Sand_Total >= 1000 && TrowlCheck == false && SuperTrowlCheck == false:
		Sand_Total -= 1000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Trowl")
		TrowlCheck = true
		
		#spawn TrowlSprite
		$TrowlSprite.visible = true
		var trowl_tween := create_tween().bind_node($TrowlSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		trowl_tween.tween_property($TrowlSprite, "position", Vector2(775.0, 680), 0.2)#.from(Vector2(0,0))
		trowl_audio.play()
		
		# update text with list of items here
		Sand = Sand * 1.2
		TrowlUpgradeCost = 2000
		TrowlCounter += 1
		$ScrollContainer/VBoxContainer/TrowlButton.text = "Upgrade Trowl " +"\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)

func _on_pan_timer_timeout() -> void:
# checking and setting Pan Button conditions
	if Sand_Total >= 3000 && !listItems.has("Pan"):
		$ScrollContainer/VBoxContainer/PanButton.text = "Buy Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/PanButton.disabled = false
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 3000 && !listItems.has("Pan"):
		$ScrollContainer/VBoxContainer/PanButton.disabled = true
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost:
		$ScrollContainer/VBoxContainer/PanButton.disabled = false
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost:
		$ScrollContainer/VBoxContainer/PanButton.disabled = true
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		$ScrollContainer/VBoxContainer/PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/PanButton.disabled = false
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost && PanCounter == 11:
		$ScrollContainer/VBoxContainer/PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/PanButton.disabled = true
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperPanCheck == true && PanCounter == 21:
		$ScrollContainer/VBoxContainer/PanButton.text = "Max Pan" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/PanButton.disabled = true
		$ScrollContainer/VBoxContainer/PanButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
		
func _on_pan_button_pressed() -> void:
#$ScrollContainer/VBoxContainer/PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if PanCheck == false && SuperPanCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter < 11:
		Sand_Total -= PanUpgradeCost
		PanCounter += 1
		
	#multiplyer for bigger upgrades
		if PanCounter == 11:
			PanUpgradeCost = PanUpgradeCost * 2.5
			$ScrollContainer/VBoxContainer/PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		else:
			PanUpgradeCost = PanUpgradeCost + (200 * PanCounter)
			$ScrollContainer/VBoxContainer/PanButton.text = "Upgrade Pan " +"\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.2
		
	elif PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		listItems.append("Super Pan")		
		SuperPanCheck = true
		PanCheck = false	
		$PanSprite.frame = 2
		
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.6
		PanUpgradeCost = PanUpgradeCost + (1000 * PanCounter)
		PanCounter += 1
		$ScrollContainer/VBoxContainer/PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
	
	elif SuperPanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter > 11:
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.35
		PanUpgradeCost = PanUpgradeCost + (1000 * PanCounter)
		PanCounter += 1
		$ScrollContainer/VBoxContainer/PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)

	if Sand_Total >= 3000 && PanCheck == false && SuperPanCheck == false:
		Sand_Total -= 3000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Pan")
		PanCheck = true
		
		#spawn PanSprite
		$PanSprite.visible = true
		var pan_tween := create_tween().bind_node($PanSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		pan_tween.tween_property($PanSprite, "position", Vector2(845.0, 690), 0.2)#.from(Vector2(0,0))
		pan_audio.play()
		
		# update text with list of items here
		Sand = Sand * 1.3
		PanUpgradeCost = 4000
		PanCounter += 1
		$ScrollContainer/VBoxContainer/PanButton.text = "Upgrade Pan " +"\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)

func _on_shovel_timer_timeout() -> void:
# checking and setting Shovel Button conditions
	if Sand_Total >= 10000 && !listItems.has("Shovel"):
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Buy Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = false
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 10000 && !listItems.has("Shovel"):
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = true
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost:
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = false
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost:
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = true
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost && ShovelCounter == 11:
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" +  NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = false
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost && ShovelCounter == 11:
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" +  NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = true
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperShovelCheck == true && ShovelCounter == 26:
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Max Shovel" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/ShovelButton.disabled = true
		$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_shovel_button_pressed() -> void:
#$ScrollContainer/VBoxContainer/ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if ShovelCheck == false && SuperShovelCheck == false:
		pass
	else:
		button_click_sfx.play()	
			
	if ShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter < 11:
		Sand_Total -= ShovelUpgradeCost
		ShovelCounter += 1
		
	#multiplyer for bigger upgrades
		if ShovelCounter == 11:
			ShovelUpgradeCost = ShovelUpgradeCost * 2.5
			$ScrollContainer/VBoxContainer/ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		else:
			ShovelUpgradeCost = ShovelUpgradeCost + (600 * ShovelCounter)
			$ScrollContainer/VBoxContainer/ShovelButton.text = "Upgrade Shovel " +"\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.3
		
	elif ShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter == 11:
		listItems.append("Super Shovel")		
		SuperShovelCheck = true
		ShovelCheck = false	
		$ShovelSprite.frame = 2
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= ShovelUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.8
		ShovelUpgradeCost = ShovelUpgradeCost + (1400 * ShovelCounter)
		ShovelCounter += 1
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
	
	elif SuperShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter > 11:
		Sand_Total -= ShovelUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.55
		ShovelUpgradeCost = ShovelUpgradeCost + (1400 * ShovelCounter)
		ShovelCounter += 1
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)

	if Sand_Total >= 10000 && ShovelCheck == false && SuperShovelCheck == false:
		Sand_Total -= 10000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Shovel")
		ShovelCheck = true
		
		#spawn ShovelSprite
		$ShovelSprite.visible = true
		var shovel_tween := create_tween().bind_node($ShovelSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		shovel_tween.tween_property($ShovelSprite, "position", Vector2(430.0, 540), 0.3)#.from(Vector2(0,0))
		shovel_audio.play()
		
		# update text with list of items here
		Sand = Sand * 1.5
		ShovelUpgradeCost = 20000
		ShovelCounter += 1
		$ScrollContainer/VBoxContainer/ShovelButton.text = "Upgrade Shovel " +"\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)

func _on_cls_timer_timeout() -> void:
# checking and setting Comically Large SPOON Button conditions
	if Sand_Total >= 500000 && !listItems.has("Comically Large SPOON"):
		$ScrollContainer/VBoxContainer/CLSButton.text = "Buy Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/CLSButton.disabled = false
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 500000 && !listItems.has("Comically Large SPOON"):
		$ScrollContainer/VBoxContainer/CLSButton.disabled = true
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost:
		$ScrollContainer/VBoxContainer/CLSButton.disabled = false
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost:
		$ScrollContainer/VBoxContainer/CLSButton.disabled = true
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost && CLSCounter == 11:
		$ScrollContainer/VBoxContainer/CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/CLSButton.disabled = false
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost && CLSCounter == 11:
		$ScrollContainer/VBoxContainer/CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/CLSButton.disabled = true
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif FCLSCheck == true && CLSCounter == 31:
		$ScrollContainer/VBoxContainer/CLSButton.text = "Max Spoonage" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/CLSButton.disabled = true
		$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_cls_button_pressed() -> void:
#$ScrollContainer/VBoxContainer/CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if CLSCheck == false && FCLSCheck == false:
		pass
	else:
		button_click_sfx.play()	
			
	if CLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter < 11:
		Sand_Total -= CLSUpgradeCost
		CLSCounter += 1
		
	#multiplyer for bigger upgrades
		if CLSCounter == 11:
			CLSUpgradeCost = CLSUpgradeCost * 2.5
			$ScrollContainer/VBoxContainer/CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		else:
			CLSUpgradeCost = CLSUpgradeCost + (550 * CLSCounter)
			$ScrollContainer/VBoxContainer/CLSButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.4
		
	elif CLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter == 11:
		listItems.append("Funnier Comically Large SPOON")		
		FCLSCheck = true
		CLSCheck = false	
		$CSpoonSprite.frame = 2
		
		Sand_Total -= CLSUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.8
		CLSUpgradeCost = CLSUpgradeCost + (500000 * CLSCounter)
		CLSCounter += 1
		$ScrollContainer/VBoxContainer/CLSButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
	
	elif FCLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter > 11:
		Sand_Total -= CLSUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.75
		CLSUpgradeCost = CLSUpgradeCost + (500000 * CLSCounter)
		CLSCounter += 1
		$ScrollContainer/VBoxContainer/CLSButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)

	if Sand_Total >= 500000 && CLSCheck == false && FCLSCheck == false:
		Sand_Total -= 500000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Comically Large SPOON")
		CLSCheck = true
		
		#spawn CLSSpoonSprite
		$CSpoonSprite.visible = true
		var cspoon_tween := create_tween().bind_node($CSpoonSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		cspoon_tween.tween_property($CSpoonSprite, "position", Vector2(265, 560), 0.1)#.from(Vector2(0,0))
		cspoon_audio.play()
		
		Sand = Sand * 1.75
		CLSUpgradeCost = 1000000
		CLSCounter += 1
		$ScrollContainer/VBoxContainer/CLSButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
	
func _on_dozer_timer_timeout() -> void:
# checking and setting Dozer Button conditions
	if Sand_Total >= 1500000 && !listItems.has("Dozer"):
		$ScrollContainer/VBoxContainer/DozerButton.text = "Buy Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/DozerButton.disabled = false
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 1500000 && !listItems.has("Dozer"):
		$ScrollContainer/VBoxContainer/DozerButton.disabled = true
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost:
		$ScrollContainer/VBoxContainer/DozerButton.disabled = false
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost:
		$ScrollContainer/VBoxContainer/DozerButton.disabled = true
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		$ScrollContainer/VBoxContainer/DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/DozerButton.disabled = false
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost && DozerCounter == 11:
		$ScrollContainer/VBoxContainer/DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/DozerButton.disabled = true
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif BiggerDozerCheck == true && DozerCounter == 36:
		$ScrollContainer/VBoxContainer/DozerButton.text = "Final Dozer" + "\n" + " Reached"
		$ScrollContainer/VBoxContainer/DozerButton.disabled = true
		$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_dozer_button_pressed() -> void:
#$ScrollContainer/VBoxContainer/DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if DozerCheck == false && BiggerDozerCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter < 11:
		Sand_Total -= DozerUpgradeCost
		DozerCounter += 1
		
	#multiplyer for bigger upgrades
		if DozerCounter == 11:
			DozerUpgradeCost = DozerUpgradeCost * 3
			$ScrollContainer/VBoxContainer/DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		else:
			DozerUpgradeCost = DozerUpgradeCost + (100000 * DozerCounter)
			$ScrollContainer/VBoxContainer/DozerButton.text = "Upgrade Dozer " + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.8
		
	elif DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		listItems.append("Bigger Dozer")		
		BiggerDozerCheck = true
		DozerCheck = false	
		var dozer_tween2 := create_tween().bind_node($DozerSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		$DozerSprite.frame = 2
		dozer_tween2.tween_property($DozerSprite, 'scale', Vector2(0.25,0.25), 0.3)
		
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.9
		DozerUpgradeCost = DozerUpgradeCost + (10000000 * DozerCounter)
		DozerCounter += 1
		$ScrollContainer/VBoxContainer/DozerButton.text = "Upgrade Bigger" + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
	
	elif BiggerDozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter > 11:
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 2.25
		DozerUpgradeCost = DozerUpgradeCost + (100000 * DozerCounter)
		DozerCounter += 1
		$ScrollContainer/VBoxContainer/DozerButton.text = "Upgrade Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)

	if Sand_Total >= 1500000 && DozerCheck == false && BiggerDozerCheck == false:
		Sand_Total -= 1500000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Dozer")
		DozerCheck = true
		
		#spawn DozerSprite
		$DozerSprite.visible = true
		var dozer_tween := create_tween().bind_node($DozerSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		dozer_tween.tween_property($DozerSprite, "modulate:a", 1, 0.5).from(0)
		dozer_audio.play()
		
		# update text with list of items here
		Sand = Sand * 2
		DozerUpgradeCost = 3000000
		DozerCounter += 1
		$ScrollContainer/VBoxContainer/DozerButton.text = "Upgrade Dozer " + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)

func _on_golem_timer_timeout() -> void:
# checking and setting Golem Button conditions
	if Sand_Total >= 10000000 && !listItems.has("Golem"):
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Golem" + "\n" + str(int(GolemUpgradeCost))
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 10000000 && !listItems.has("Golem"):
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Golem") && Sand_Total >= GolemUpgradeCost:
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < GolemUpgradeCost:
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Golem") && Sand_Total >= GolemUpgradeCost && GolemCounter == 5:
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golem" + "\n" + str(int(GolemUpgradeCost))
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < GolemUpgradeCost && GolemCounter == 5:
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golem" + "\n" + str(int(GolemUpgradeCost))
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif HelperGolemCheck == true && GolemCounter == 26:
		$ScrollContainer/VBoxContainer/GolemButton.text = "Ritual" + "\n" + "Completed"
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
		
func _on_golem_buton_pressed() -> void:
	#spawn Golem Node
	var golem = golem_scene.instantiate()
	$terry.add_child(golem)
	
	if GolemCheck == false && HelperGolemCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if GolemCheck == true && Sand_Total >= GolemUpgradeCost && GolemCounter < 5:
		Sand_Total -= GolemUpgradeCost
		GolemCounter += 1
		
	#multiplyer for bigger upgrades
		if GolemCounter == 5:
			GolemUpgradeCost = GolemUpgradeCost * 5
			$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golems" + "\n" + str(int(GolemUpgradeCost))
		else:
			GolemUpgradeCost = GolemUpgradeCost + (10000000 * GolemCounter)
			$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Golem " + "\n" + str(int(GolemUpgradeCost))

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.5
		
	elif GolemCheck == true && Sand_Total >= GolemUpgradeCost && GolemCounter == 5:
		listItems.append("Helper Golem")		
		HelperGolemCheck = true
		GolemCheck = false	
		
		Sand_Total -= GolemUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		#Sand = Sand * 1.5
		GolemUpgradeCost = GolemUpgradeCost + (10000000 * GolemCounter)
		GolemCounter += 1
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Helper" + "\n" + "Golem" + "\n" + str(int(GolemUpgradeCost))
	
	elif HelperGolemCheck == true && Sand_Total >= GolemUpgradeCost && GolemCounter > 5:
		Sand_Total -= GolemUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		#golem now gains Sand via horse timer
		GolemUpgradeCost = GolemUpgradeCost + (10000000 * GolemCounter)
		GolemCounter += 1
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Helper " + "\n" + "Golem" + "\n" + str(int(GolemUpgradeCost))

	if Sand_Total >= 10000000 && GolemCheck == false && HelperGolemCheck == false:
		Sand_Total -= 10000000
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Golem")
		GolemCheck = true
		
		Sand = Sand * 1.5
		GolemUpgradeCost = 35000000
		GolemCounter += 1
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Golem " + "\n" + str(int(GolemUpgradeCost))
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)

func _on_cat_button_pressed() -> void:
	#Space Cat will have quick time events that 2x your Space Sand total each time
	get_node("CatQTETimer").start()
	SpaceCatCounter += 1
	if SpaceCatCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if SpaceCatCheck == true && Space_Sand >= SpaceCatUpgradeCost:
		Space_Sand -= SpaceCatUpgradeCost
		SpaceCatUpgradeCost *= 3.5
		
		SC_Check_Min -= .10
		SC_Check_Max -= .10
		#Space_Sand = Space_Sand * 2
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)

	if Space_Sand == 0 && SpaceCatCheck == false:
		Space_Sand += 1
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
		Sand_Total = 0
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("SpaceCat")
		SpaceCatCheck = true
		
		#spawn SpaceCatSprite
		$"CatSprite-o".visible = true
		var cat_tween := create_tween().bind_node($"CatSprite-o").set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		cat_tween.tween_property($"CatSprite-o", "modulate:a", 1, 0.5).from(0)
		#cat_audio.play()
		
		# update text with list of items here
		Space_Sand = Space_Sand * 2
		SpaceCatUpgradeCost *= 3.5
		$ScrollContainer/VBoxContainer/CatButton.text = "Pray Harder" + "\n" + "to Space Cat" + "\n" + NumberFormatter.format_clicker_number(SpaceCatUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Space_Sand_Mult, 3)
	print("Min is " + str(SC_Check_Min))
	print("Max is " + str(SC_Check_Max))
	
func _on_cat_timer_timeout() -> void:
# checking and setting Cat Button conditions
	if space_check == true:
		if Space_Sand == 0 && SpaceCatCheck == false:
			$ScrollContainer/VBoxContainer/CatButton.text = "Pray to" + "\n" + "Space Cat" + "\n" + "Every Sand $"
			$ScrollContainer/VBoxContainer/CatButton.disabled = false
			$ScrollContainer/VBoxContainer/CatButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		#else:
			#$ScrollContainer/VBoxContainer/CatButton.disabled = true
			#$ScrollContainer/VBoxContainer/CatButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
			
		if SpaceCatCheck == true && Space_Sand >= SpaceCatUpgradeCost && SpaceCatCounter >= 1:
			$ScrollContainer/VBoxContainer/CatButton.text = "Pray Harder" + "\n" + "to Space Cat" + "\n" + NumberFormatter.format_clicker_number(SpaceCatUpgradeCost, 5)
			$ScrollContainer/VBoxContainer/CatButton.disabled = false
			$ScrollContainer/VBoxContainer/CatButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif SpaceCatCheck == true && Space_Sand < SpaceCatUpgradeCost && SpaceCatCounter >= 1:
			$ScrollContainer/VBoxContainer/CatButton.text = "Pray Harder" + "\n" + "to Space Cat" + "\n" + NumberFormatter.format_clicker_number(SpaceCatUpgradeCost, 5)
			$ScrollContainer/VBoxContainer/CatButton.disabled = true
			$ScrollContainer/VBoxContainer/CatButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
func _on_coin_timer_timeout() -> void:
	# random coin drop time
	#var coin_drop:= RandomNumberGenerator.new()
	#randomize()
	#Coin_Spawn_Time = randf_range(150.05, 300.05)
	#Coin_Spawn_Time = randf_range(1, 2)
	
	#horse coins stop spawning in space
	if !$Background.frame == 1:
		Coin_Spawn_Time = randf_range(5, 8)
		#Coin_Spawn_Time = randf_range(100.05, 400.01)
		$CoinTimer.wait_time = Coin_Spawn_Time
	
		#adds it below Terry to put behind pause menu
		var coin = coin_scene.instantiate()
		$StaticBody2D2.add_child(coin)

func _on_horse_timer_timeout() -> void:
	#horse only triggers on Earth
	if !$Background.frame == 1:
		Sand_Total += Horse_Sand_Eat
		Sand_Total_Eaten += Horse_Sand_Eat

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
	
	if HelperGolemCheck == true:
		Sand_Total += GolemCounter * Sand
		Sand_Total_Eaten += GolemCounter * Sand

func _on_cheat_pressed() -> void:
	Sand_Total += 9223372000000000000
	Sand_Total_Eaten += 9223372000000000000
	auto_input()
	
func _on_space_cheat_pressed() -> void:
	space_check = false
	SuperSpoonCheck = true
	SuperTrowlCheck = true
	SuperPanCheck = true
	SuperShovelCheck = true
	FCLSCheck = true
	BiggerDozerCheck = true
	Sand_Total_Eaten = 9223372000000000000
	
# loading save stops timers for some reason
func start_timers():
	get_node("AutoSaveTimer").autostart = true
	
	if space_check == false:
		get_node("CoinTimer").autostart = true
		get_node("HorseTimer").autostart = true
		get_node("SpoonTimer").autostart = true
		get_node("TrowlTimer").autostart = true
		get_node("PanTimer").autostart = true
		get_node("ShovelTimer").autostart = true
		get_node("CLSTimer").autostart = true
		get_node("DozerTimer").autostart = true
		get_node("GolemTimer").autostart = true
	else:
		get_node("CoinTimer").autostart = false
		get_node("HorseTimer").autostart = false
		get_node("SpoonTimer").autostart = false
		get_node("TrowlTimer").autostart = false
		get_node("PanTimer").autostart = false
		get_node("ShovelTimer").autostart = false
		get_node("CLSTimer").autostart = false
		get_node("DozerTimer").autostart = false
		get_node("GolemTimer").autostart = false
		
		get_node("CatTimer").start()
		if listItems.has("SpaceCat"):
			get_node("CatQTETimer").start()

func _on_auto_save_timer_timeout() -> void:
	#print("Game saved teehee")
	var root = get_tree().current_scene
	var scene = PackedScene.new()
	scene.pack(root)
	ResourceSaver.save(scene, "user://SavedGame.tscn")
	
	if (!space_check && SuperSpoonCheck && SuperTrowlCheck && SuperPanCheck && SuperShovelCheck && FCLSCheck && BiggerDozerCheck && Sand_Total_Eaten >= 9223372000000000000):
		space_check = true
		# change background and sprite rotations
		if $Background.frame == 0:
			var tween = create_tween()
			tween.tween_property($Background, "modulate:a", 0.0, 5.0)
			
			await tween.finished
			
			$Background.frame = 1
			
			create_tween().tween_property($Background, "modulate:a", 1.0, 5.0)
			Sand = 0
			#stop and start the correct timers as scene transitions
			start_timers()
			$Sand_Mult.text = "Consumption Rate: 0X"
			$Space_Sand_Ate.text = "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][wave]Space Sand: 0"
			$Space_Sand_Ate.visible = true
			$ScrollContainer/VBoxContainer/CatButton.tooltip_text = "Makes Quick Time Events Occur Faster"

# picking and spawning the letters on Space Cat, also setting the range of wait time
func _on_cat_qte_timer_timeout() -> void:
	var keyNode = QTE.instantiate()
	
	#loading qte rates
	keyNode.finished.connect(_on_key_finished)
	keyNode.qte_success.connect(_on_qte_success) # connect the signal here
	keyNode.qte_failure.connect(_on_ate_fail)
	
	var keyData = keyList.pick_random()
	keyNode.keyCode = keyData.keyCode
	keyNode.keyString = keyData.keyString

	$CanvasLayer/ControlContainer.add_child(keyNode)

	key_count += 1
	
	$CatQTETimer.wait_time = randf_range(SC_Check_Min, SC_Check_Max)
	
func _on_key_finished(keySuc):
	keyPressedList.append(keySuc)
#success on the cat qte
func _on_qte_success(amount_Space_Sand):
	#print("got me right")
	if SpaceCatCounter <= 1:
		SpaceCatCounter = 2
	else:
		SpaceCatCounter = SpaceCatCounter * 2
	Space_Sand = amount_Space_Sand * SpaceCatCounter
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	#print("Space Cat Counter is " + str(SpaceCatCounter))
	#print("Space Sand is at " + str(Space_Sand) + " by being x by " + str(amount_Space_Sand))
#failure on the cat qte
func _on_ate_fail(amount_Space_Sand):
	if SpaceCatCounter >= 2 && Space_Sand >= 2:
		#print("got me wrong")
		#print("Space Cat Counter is " + str(SpaceCatCounter) + " / by 2")
		@warning_ignore("integer_division")
		SpaceCatCounter = SpaceCatCounter / amount_Space_Sand
		Space_Sand = Space_Sand / SpaceCatCounter
		#print("Space Sand is at " + str(Space_Sand) + " by " + str(Space_Sand) + " being / by " + str(SpaceCatCounter))
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	else:
		pass
