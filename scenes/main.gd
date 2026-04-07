@tool
extends Node2D

@export var Sand: float = 1
@export var Sand_Total: float 
@export var Sand_Total_Eaten: float 
@export var Space_Sand: float
@export var Space_Sand_Mult: float

var next_input: bool = false
var dev_bool: bool = false
@export var s_label: String
@export var s_label_d: String

@onready var button_click_sfx: AudioStreamPlayer2D = $ScrollContainer/VBoxContainer/ButtonClickSFX
@onready var button_hover_sfx: AudioStreamPlayer2D = $ScrollContainer/VBoxContainer/ButtonHoverSFX
@onready var terry_play = $terry
var coin_scene: PackedScene = load("res://scenes/horse_coin.tscn")
var golem_scene: PackedScene = load("res://scenes/golem_2d.tscn")
var shrimp_scene: PackedScene = load("res://scenes/space_shrimp.tscn")
var worm_scene: PackedScene = load("res://scenes/space_worm.tscn")
var earned_points: PackedScene = load("res://scenes/points.tscn")
var animals_scene: PackedScene = load("res://scenes/cat&turt.tscn")

@onready var bad_audio: AudioStreamPlayer2D = $negtone
@onready var good_audio: AudioStreamPlayer2D = $postone

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool
@onready var spoon_audio: AudioStreamPlayer2D = $SpoonAudio
@onready var SpoonButton: Button = $ScrollContainer/VBoxContainer/SpoonButton

@export var TrowlUpgradeCost: float = 1000
@export var TrowlCounter: float
@export var TrowlCheck: bool
@export var SuperTrowlCheck: bool
@onready var trowl_audio: AudioStreamPlayer2D = $TrowlAudio
@onready var TrowlButton: Button = $ScrollContainer/VBoxContainer/TrowlButton

@export var PanUpgradeCost: float = 3000
@export var PanCounter: float
@export var PanCheck: bool
@export var SuperPanCheck: bool
@onready var pan_audio: AudioStreamPlayer2D = $PanAudio
@onready var PanButton: Button = $ScrollContainer/VBoxContainer/PanButton

@export var ShovelUpgradeCost: float = 10000
@export var ShovelCounter: float
@export var ShovelCheck: bool
@export var SuperShovelCheck: bool
@onready var shovel_audio: AudioStreamPlayer2D = $ShovelAudio
@onready var ShovelButton: Button = $ScrollContainer/VBoxContainer/ShovelButton

@export var CLSUpgradeCost: float = 500000
@export var CLSCounter: float
@export var CLSCheck: bool
@export var FCLSCheck: bool
@onready var cspoon_audio: AudioStreamPlayer2D = $CSpoonAudio
@onready var cspoonButton: Button = $ScrollContainer/VBoxContainer/CLSButton

@export var DozerUpgradeCost: float = 150000000
@export var DozerCounter: float
@export var DozerCheck: bool
@export var BiggerDozerCheck: bool
@onready var dozer_audio: AudioStreamPlayer2D = $DozerAudio
@onready var DozerButton: Button = $ScrollContainer/VBoxContainer/DozerButton

@export var GolemUpgradeCost: float = 5000000000
@export var GolemCounter: float
@export var GolemCheck: bool
@export var HelperGolemCheck: bool #have golems start automatically eating sand
#@onready var Golum_audio: AudioStreamPlayer2D = $GolumAudio

@export var SpaceCatUpgradeCost: float = 1
@export var SpaceCatCounter: int
@export var SpaceCatCheck: bool
@onready var cat_audio: AudioStreamPlayer2D = $CatAudio
const QTE = preload("res://scenes/QTE_Letter.tscn")
var QTE_var = preload("res://scenes/QTE_Letter.tscn")
var qte1 = QTE_var.instantiate()

@export var SC_Check_Min: float = 3.0
@export var SC_Check_Max: float = 10.0
@export var active_key_node = null

@export var SpaceShrimpCounter: int = 0
@export var SpaceShrimpUpgradeCost: float = 50000

@export var SpaceWhaleSum: float = 1000
@export var SpaceWhaleCheck: bool
@export var SpaceWhaleUpgradeCost: int = 5
@export var SpaceWhaleTweenGrowth: float = 0.025
@onready var whale_audio: AudioStreamPlayer2D = $WhaleAudio

@export var SpaceSquirrelCheck: bool
@export var SpaceSquirrelGambleCost: float = 1000000000
@export var SpaceSquirrelGamble: float
@onready var squirrel_audio: AudioStreamPlayer2D = $SquirrelAudio

@export var Worm_Spawn_Time: float
@export var Worm_Sand_Eat: int = 500000000000
@export var SpaceWormCheck: bool
@export var SpaceWormUpgradeCost: float = 1000000000000000

@export var SpaceTurtleUpgradeCounter: int
@export var SpaceTurtleUpgradeCost: float = 25000000000000000
@export var SpaceTurtleCheck: bool
@export var SpaceTurtleMultiplyer: float = 1.5

@export var HorrorSummonCost: int = 9223372036854775807# can't load larger int so go with this
var HorrorSummonAdd: int = 10#1250550000000000000000000

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
	
	#print("$CatQTETimer is_autostart:", $CatQTETimer.autostart, "is_stopped:", $CatQTETimer.is_stopped())
	#if listItems.has("SpaceCat"):
		#get_node("CatQTETimer").start()
		#print("started", " ", $CatQTETimer.is_stopped())
		#$CatQTETimer.start()
		#print("started 2", " ", $CatQTETimer.is_stopped())
	#$CatQTETimer.timeout.connect(_on_cat_qte_timer_timeout, [], CONNECT_ONESHOT) # optional for testing
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
				node.set_meta("rotation_speed", float_rng.randf_range(-12.0, 12.0))# random float speed left or right
			
			# Assign a unique float amplitude once (height)
			if not node.has_meta("float_amplitude"):
				node.set_meta("float_amplitude", float_rng.randf_range(5.0, 30.0)) # pixels
				
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
				node.set_meta("float_amplitude", 10) # pixels
				
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
		$Night.visible = false
	
	var moving := Input.is_action_pressed("left") \
	or Input.is_action_pressed("right")
		
	# very common way I'll display text on screen
	if $Sand_Ate.text == "":
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	if $Sand_Dollar.text == "":
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
	# Terry cheat
	#auto_input()
	# dev cheat buttons toggle
	if Input.is_action_just_pressed("dev_buttons") && dev_bool == false:
		$Cheat.visible = true
		$SpaceCheat.visible = true
		$SpaceCheat2.visible = true
		dev_bool = true
	elif Input.is_action_just_pressed("dev_buttons") && dev_bool == true:
		$Cheat.visible = false
		$SpaceCheat.visible = false
		$SpaceCheat2.visible = false
		dev_bool = false
		
	if Input.is_action_just_pressed("left") && next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		next_input = true
		
		if terry_play:
			terry_play.set_moving(moving)
					
		#spawn multiplcation		
		#var pts = earned_points.instantiate()
		#pts.text = "+" + NumberFormatter.format_clicker_number(Sand, 5)
		#pts.global_position.x = 439.0
		#pts.global_position.y = 642.07
		#pts.rotation = 25
		#add_child(pts)
	
	if Input.is_action_just_pressed("right") && next_input == true:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		next_input = false
		
		if terry_play:
			terry_play.set_moving(moving)
		
		#spawn multiplcation		
		#var pts = earned_points.instantiate()
		#pts.text = "+" + NumberFormatter.format_clicker_number(Sand, 5)
		#pts.global_position.x = 732.0
		#pts.global_position.y = 642.07
		#pts.rotation = 44.25
		#add_child(pts)
			
func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	if Sand_Total >= SpoonUpgradeCost && !listItems.has("Spoon"):
		SpoonButton.text = "Buy Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		SpoonButton.disabled = false
		SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && !listItems.has("Spoon"):
		SpoonButton.disabled = true
		SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost:
		SpoonButton.disabled = false
		SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost:
		SpoonButton.disabled = true
		SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		SpoonButton.disabled = false
		SpoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && SpoonCounter == 11:
		SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		SpoonButton.disabled = true
		SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)		
	elif SuperSpoonCheck == true && SpoonCounter >= 14:
		SpoonButton.text = "Max Spoonage" + "\n" + " Reached"
		SpoonButton.disabled = true
		SpoonButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
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
			SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		else:
			SpoonUpgradeCost = SpoonUpgradeCost + (100 * SpoonCounter)
			SpoonButton.text = "Upgrade Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)

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
		SpoonButton.text = "Upgrade" + "\n" + " Super Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
	
	elif SuperSpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter > 11:
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.2
		SpoonUpgradeCost = SpoonUpgradeCost + (400 * SpoonCounter)
		SpoonCounter += 1
		SpoonButton.text = "Upgrade" + "\n" + " Super Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)

	if Sand_Total >= SpoonUpgradeCost && SpoonCheck == false && SuperSpoonCheck == false:
		Sand_Total -= SpoonUpgradeCost
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
		SpoonButton.text = "Upgrade Spoon " + "\n" + NumberFormatter.format_clicker_number(SpoonUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
	
# tell player what they get from Spoon upgrades
func _on_spoon_button_mouse_entered() -> void:
	if SpoonButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if SpoonCheck == false && SpoonCounter != 11 && SuperSpoonCheck == false:
		SpoonButton.tooltip_text = "Multiply Consumption rate by " + "1.1"
	elif SuperSpoonCheck == false && SpoonCounter == 11:
		SpoonButton.tooltip_text = "Multiply Consumption rate by " + "1.3"
		
	if SuperSpoonCheck == true && SpoonCounter > 11:
		SpoonButton.tooltip_text = "Multiply Consumption rate by " + "1.2"
		if SpoonCounter >= 14:
			SpoonButton.tooltip_text = ""
		
func _on_trowl_timer_timeout() -> void:
# checking and setting Trowl Button conditions
	if Sand_Total >= TrowlUpgradeCost && !listItems.has("Trowl"):
		TrowlButton.text = "Buy Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		TrowlButton.disabled = false
		TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost && !listItems.has("Trowl"):
		TrowlButton.disabled = true
		TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost:
		TrowlButton.disabled = false
		TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost:
		TrowlButton.disabled = true
		TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		TrowlButton.disabled = false
		TrowlButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost && TrowlCounter == 11:
		TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		TrowlButton.disabled = true
		TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperTrowlCheck == true && TrowlCounter >= 16:
		TrowlButton.text = "Max Trowl" + "\n" + " Reached"
		TrowlButton.disabled = true
		TrowlButton.modulate = Color(0.0, 0.0, 0.0, 1.0)

func _on_trowl_button_pressed() -> void:
	#TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
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
			TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		else:
			TrowlUpgradeCost = TrowlUpgradeCost + (175 * TrowlCounter)
			TrowlButton.text = "Upgrade Trowl " +"\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)

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
		TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
	
	elif SuperTrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter > 11:
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.25
		TrowlUpgradeCost = TrowlUpgradeCost + (800 * TrowlCounter)
		TrowlCounter += 1
		TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)

	if Sand_Total >= TrowlUpgradeCost && TrowlCheck == false && SuperTrowlCheck == false:
		Sand_Total -= TrowlUpgradeCost
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
		TrowlButton.text = "Upgrade Trowl " +"\n" + NumberFormatter.format_clicker_number(TrowlUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#trowl hover text
func _on_trowl_button_mouse_entered() -> void:
	if TrowlButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if TrowlCheck == false && TrowlCounter != 11 && SuperTrowlCheck == false:
		TrowlButton.tooltip_text = "Multiply Consumption rate by " + "1.2"
	elif SuperTrowlCheck == false && TrowlCounter == 11:
		TrowlButton.tooltip_text = "Multiply Consumption rate by " + "1.4"
		
	if SuperTrowlCheck == true && TrowlCounter > 11:
		TrowlButton.tooltip_text = "Multiply Consumption rate by " + "1.25"
		if TrowlCounter >= 16:
			TrowlButton.tooltip_text = ""
	
func _on_pan_timer_timeout() -> void:
# checking and setting Pan Button conditions
	if Sand_Total >= PanUpgradeCost && !listItems.has("Pan"):
		PanButton.text = "Buy Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		PanButton.disabled = false
		PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost && !listItems.has("Pan"):
		PanButton.disabled = true
		PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost:
		PanButton.disabled = false
		PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost:
		PanButton.disabled = true
		PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		PanButton.disabled = false
		PanButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost && PanCounter == 11:
		PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		PanButton.disabled = true
		PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperPanCheck == true && PanCounter >= 21:
		PanButton.text = "Max Pan" + "\n" + " Reached"
		PanButton.disabled = true
		PanButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
		
func _on_pan_button_pressed() -> void:
#PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
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
			PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		else:
			PanUpgradeCost = PanUpgradeCost + (215 * PanCounter)
			PanButton.text = "Upgrade Pan " +"\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.25
		
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
		PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
	
	elif SuperPanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter > 11:
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.35
		PanUpgradeCost = PanUpgradeCost + (1000 * PanCounter)
		PanCounter += 1
		PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)

	if Sand_Total >= PanUpgradeCost && PanCheck == false && SuperPanCheck == false:
		Sand_Total -= PanUpgradeCost
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
		PanButton.text = "Upgrade Pan " +"\n" + NumberFormatter.format_clicker_number(PanUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#Pan tooltip
func _on_pan_button_mouse_entered() -> void:
	if PanButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if PanCheck == false && PanCounter != 11 && SuperPanCheck == false:
		PanButton.tooltip_text = "Multiply Consumption rate by " + "1.3"
	elif SuperPanCheck == false && PanCounter == 11:
		PanButton.tooltip_text = "Multiply Consumption rate by " + "1.6"
		
	if SuperPanCheck == true && PanCounter > 11:
		PanButton.tooltip_text = "Multiply Consumption rate by " + "1.35"
		if PanCounter >= 21:
			PanButton.tooltip_text = ""
	
func _on_shovel_timer_timeout() -> void:
# checking and setting Shovel Button conditions
	if Sand_Total >= ShovelUpgradeCost && !listItems.has("Shovel"):
		ShovelButton.text = "Buy Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		ShovelButton.disabled = false
		ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost && !listItems.has("Shovel"):
		ShovelButton.disabled = true
		ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost:
		ShovelButton.disabled = false
		ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost:
		ShovelButton.disabled = true
		ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost && ShovelCounter == 11:
		ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		ShovelButton.disabled = false
		ShovelButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost && ShovelCounter == 11:
		ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		ShovelButton.disabled = true
		ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperShovelCheck == true && ShovelCounter >= 26:
		ShovelButton.text = "Max Shovel" + "\n" + " Reached"
		ShovelButton.disabled = true
		ShovelButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_shovel_button_pressed() -> void:
#ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if ShovelCheck == false && SuperShovelCheck == false:
		pass
	else:
		button_click_sfx.play()	
			
	if ShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter < 11:
		Sand_Total -= ShovelUpgradeCost
		ShovelCounter += 1
		
	#multiplyer for bigger upgrades
		if ShovelCounter == 11:
			ShovelUpgradeCost = ShovelUpgradeCost * 3.0
			ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		else:
			ShovelUpgradeCost = ShovelUpgradeCost + (900 * ShovelCounter)
			ShovelButton.text = "Upgrade Shovel " +"\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)

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
		ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
	
	elif SuperShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter > 11:
		Sand_Total -= ShovelUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.55
		ShovelUpgradeCost = ShovelUpgradeCost + (1400 * ShovelCounter)
		ShovelCounter += 1
		ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)

	if Sand_Total >= ShovelUpgradeCost && ShovelCheck == false && SuperShovelCheck == false:
		Sand_Total -= ShovelUpgradeCost
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
		ShovelButton.text = "Upgrade Shovel " +"\n" + NumberFormatter.format_clicker_number(ShovelUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#shovel tooltips
func _on_shovel_button_mouse_entered() -> void:
	if ShovelButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if ShovelCheck == false && ShovelCounter != 11 && SuperShovelCheck == false:
		ShovelButton.tooltip_text = "Multiply Consumption rate by " + "1.5"
	elif SuperShovelCheck == false && ShovelCounter == 11:
		ShovelButton.tooltip_text = "Multiply Consumption rate by " + "1.8"
		
	if SuperShovelCheck == true && ShovelCounter > 11:
		ShovelButton.tooltip_text = "Multiply Consumption rate by " + "1.55"
		if ShovelCounter >= 26:
			ShovelButton.tooltip_text = ""
	
func _on_cls_timer_timeout() -> void:
# checking and setting Comically Large SPOON Button conditions
	if Sand_Total >= CLSUpgradeCost && !listItems.has("Comically Large SPOON"):
		cspoonButton.text = "Buy Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		cspoonButton.disabled = false
		cspoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost && !listItems.has("Comically Large SPOON"):
		cspoonButton.disabled = true
		cspoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost:
		cspoonButton.disabled = false
		cspoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost:
		cspoonButton.disabled = true
		cspoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost && CLSCounter == 11:
		cspoonButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		cspoonButton.disabled = false
		cspoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost && CLSCounter == 11:
		cspoonButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		cspoonButton.disabled = true
		cspoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif FCLSCheck == true && CLSCounter >= 31:
		cspoonButton.text = "Max Spoonage" + "\n" + " Reached"
		cspoonButton.disabled = true
		cspoonButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_cls_button_pressed() -> void:
#cspoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if CLSCheck == false && FCLSCheck == false:
		pass
	else:
		button_click_sfx.play()	
			
	if CLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter < 11:
		Sand_Total -= CLSUpgradeCost
		CLSCounter += 1
		
	#multiplyer for bigger upgrades
		if CLSCounter == 11:
			CLSUpgradeCost = CLSUpgradeCost * 3.5
			cspoonButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		else:
			CLSUpgradeCost = CLSUpgradeCost + (1000 * CLSCounter)
			cspoonButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)

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
		Sand = Sand * 1.85
		CLSUpgradeCost = CLSUpgradeCost + (500000 * CLSCounter)
		CLSCounter += 1
		cspoonButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
	
	elif FCLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter > 11:
		Sand_Total -= CLSUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 1.7569
		CLSUpgradeCost = CLSUpgradeCost + (500000 * CLSCounter)
		CLSCounter += 1
		cspoonButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)

	if Sand_Total >= CLSUpgradeCost && CLSCheck == false && FCLSCheck == false:
		Sand_Total -= CLSUpgradeCost
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
		cspoonButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + NumberFormatter.format_clicker_number(CLSUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#cls tooltips	
func _on_cls_button_mouse_entered() -> void:
	if cspoonButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if CLSCheck == false && CLSCounter != 11 && FCLSCheck == false:
		cspoonButton.tooltip_text = "Multiply Consumption rate by " + "1.75"
	elif FCLSCheck == false && CLSCounter == 11:
		cspoonButton.tooltip_text = "Multiply Consumption rate by " + "1.85"
		
	if CLSCheck == true && CLSCounter > 11:
		cspoonButton.tooltip_text = "Multiply Consumption rate by " + "1.7569"
		if CLSCounter >= 31:
			cspoonButton.tooltip_text = ""
	
func _on_dozer_timer_timeout() -> void:
# checking and setting Dozer Button conditions
	if Sand_Total >= DozerUpgradeCost && !listItems.has("Dozer"):
		DozerButton.text = "Buy Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		DozerButton.disabled = false
		DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost && !listItems.has("Dozer"):
		DozerButton.disabled = true
		DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost:
		DozerButton.disabled = false
		DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost:
		DozerButton.disabled = true
		DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		DozerButton.disabled = false
		DozerButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost && DozerCounter == 11:
		DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		DozerButton.disabled = true
		DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif BiggerDozerCheck == true && DozerCounter >= 36:
		DozerButton.text = "Final Dozer" + "\n" + " Reached"
		DozerButton.disabled = true
		DozerButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_dozer_button_pressed() -> void:
#DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if DozerCheck == false && BiggerDozerCheck == false:
		pass
	else:
		button_click_sfx.play()	
		
	if DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter < 11:
		Sand_Total -= DozerUpgradeCost
		DozerCounter += 1
		
	#multiplyer for bigger upgrades
		if DozerCounter == 11:
			DozerUpgradeCost = DozerUpgradeCost * 4.5
			DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		else:
			DozerUpgradeCost = DozerUpgradeCost + (1000000 * DozerCounter)
			DozerButton.text = "Upgrade Dozer " + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 2
		
	elif DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		listItems.append("Bigger Dozer")		
		BiggerDozerCheck = true
		DozerCheck = false	
		var dozer_tween2 := create_tween().bind_node($DozerSprite).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		$DozerSprite.frame = 1
		dozer_tween2.tween_property($DozerSprite, 'scale', Vector2(0.25,0.25), 0.3)
		
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 2.5
		DozerUpgradeCost = DozerUpgradeCost + (10000000 * DozerCounter)
		DozerCounter += 1
		DozerButton.text = "Upgrade Bigger" + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
	
	elif BiggerDozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter > 11:
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		Sand = Sand * 2.25
		DozerUpgradeCost = DozerUpgradeCost + (100000 * DozerCounter)
		DozerCounter += 1
		DozerButton.text = "Upgrade Bigger " + "\n" + "Dozer" + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)

	if Sand_Total >= DozerUpgradeCost && DozerCheck == false && BiggerDozerCheck == false:
		Sand_Total -= DozerUpgradeCost
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
		DozerUpgradeCost = 30000000
		DozerCounter += 1
		DozerButton.text = "Upgrade Dozer " + "\n" + NumberFormatter.format_clicker_number(DozerUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#dozer tooltip
func _on_dozer_button_mouse_entered() -> void:
	if DozerButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if DozerCheck == false && DozerCounter != 11 && BiggerDozerCheck == false:
		DozerButton.tooltip_text = "Multiply Consumption rate by " + "2"
	elif BiggerDozerCheck == false && DozerCounter == 11:
		DozerButton.tooltip_text = "Multiply Consumption rate by " + "2.5"
		
	if DozerCheck == true && DozerCounter > 11:
		DozerButton.tooltip_text = "Multiply Consumption rate by " + "2.25"
		if DozerCounter >= 36:
			DozerButton.tooltip_text = ""

func _on_golem_timer_timeout() -> void:
# checking and setting Golem Button conditions
	if Sand_Total >= GolemUpgradeCost && !listItems.has("Golem"):
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Golem" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < GolemUpgradeCost && !listItems.has("Golem"):
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Golem") && Sand_Total >= GolemUpgradeCost:
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < GolemUpgradeCost:
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Golem") && Sand_Total >= GolemUpgradeCost && GolemCounter == 5:
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golem" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/GolemButton.disabled = false
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < GolemUpgradeCost && GolemCounter == 5:
		$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golem" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/GolemButton.disabled = true
		$ScrollContainer/VBoxContainer/GolemButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif HelperGolemCheck == true && GolemCounter >= 26:
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
			GolemUpgradeCost = GolemUpgradeCost * 7.5
			$ScrollContainer/VBoxContainer/GolemButton.text = "Buy Helper " + "\n" + "Golems" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
		else:
			GolemUpgradeCost = GolemUpgradeCost + (100000000 * GolemCounter)
			$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Golem " + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)

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
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Helper" + "\n" + "Golem" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
	
	elif HelperGolemCheck == true && Sand_Total >= GolemUpgradeCost && GolemCounter > 5:
		Sand_Total -= GolemUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		#golem now gains Sand via horse timer
		GolemUpgradeCost = GolemUpgradeCost + (10000000 * GolemCounter)
		GolemCounter += 1
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Helper " + "\n" + "Golem" + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)

	if Sand_Total >= GolemUpgradeCost && GolemCheck == false && HelperGolemCheck == false:
		Sand_Total -= GolemUpgradeCost
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
		
		listItems.append("Golem")
		GolemCheck = true
		
		Sand = Sand * 1.5
		GolemUpgradeCost = 35000000
		GolemCounter += 1
		$ScrollContainer/VBoxContainer/GolemButton.text = "Upgrade Golem " + "\n" + NumberFormatter.format_clicker_number(GolemUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Sand, 3)
#golem tooltips
func _on_golem_button_mouse_entered() -> void:
	if $ScrollContainer/VBoxContainer/GolemButton.disabled == false:#play sfx if button is operable
		button_hover_sfx.play()
	#hover tips for specific button upgrades (hardcoded for sanity)
	if GolemCheck == false && GolemCounter != 5:
		$ScrollContainer/VBoxContainer/GolemButton.tooltip_text = "Multiply Consumption rate by " + "1.5"
	elif HelperGolemCheck == false && GolemCounter == 5:
		$ScrollContainer/VBoxContainer/GolemButton.tooltip_text = "Have Golems collect sand for you"
		
	if HelperGolemCheck == true && GolemCounter > 5:
		$ScrollContainer/VBoxContainer/GolemButton.tooltip_text = "Increase rate of Helper Golems"
		if GolemCounter >= 26:
			$ScrollContainer/VBoxContainer/GolemButton.tooltip_text = ""
	
func _on_cat_button_pressed() -> void:
	#Space Cat will have quick time events that 2x your Space Sand total each time
	get_node("CatQTETimer").start()
	SpaceCatCounter += 1
	#idk why this is being awful but...
	var cat_aduio_stream = preload("res://sfx/nya.ogg")
	$CatAudio.stream = cat_aduio_stream
	$CatAudio.play()
		
	if SpaceCatCheck == true && Space_Sand >= SpaceCatUpgradeCost:
		Space_Sand -= SpaceCatUpgradeCost
		SpaceCatUpgradeCost *= 3.5
		#negative # checks
		if SC_Check_Min >= 0.1:
			SC_Check_Min -= .10
		if SC_Check_Max >= 1.1:
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
		
		# remove previous tool buttons
		stop_act1_timers()
		SpoonButton.queue_free()
		TrowlButton.queue_free()
		PanButton.queue_free()
		ShovelButton.queue_free()
		cspoonButton.queue_free()
		DozerButton.queue_free()
		$ScrollContainer/VBoxContainer/GolemButton.queue_free()
		
		# update text with list of items here
		Space_Sand = Space_Sand * 2
		SpaceCatUpgradeCost *= 3.5
		$ScrollContainer/VBoxContainer/CatButton.text = "Pray Harder" + "\n" + "to Space Cat" + "\n" + NumberFormatter.format_clicker_number(SpaceCatUpgradeCost, 5)
		
	$Sand_Mult.text = NumberFormatter.format_clicker_number(Space_Sand_Mult, 3)
	#print("Min is " + str(SC_Check_Min))
	#print("Max is " + str(SC_Check_Max))
	#print(str(SpaceCatUpgradeCost))
	
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
		
		if $ScrollContainer/VBoxContainer/CatButton.disabled == false:
			$ScrollContainer/VBoxContainer/CatButton.tooltip_text = "Decrease wait time of QTEs"

func _on_shrimp_button_pressed() -> void:
	var shrimpin = shrimp_scene.instantiate()
	$StaticBody2D2.add_child(shrimpin)
	shrimpin.add_to_group("spawned shrimp")
	# this line keeps it in the save (not position tho but who cares rn)
	shrimpin.owner = get_tree().current_scene
	shrimpin.play_shrimp_sfx() #play sfx
	Space_Sand -= SpaceShrimpUpgradeCost
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	SpaceShrimpCounter += 1
	SpaceShrimpUpgradeCost *= 2.5
	
func _on_shrimp_timer_timeout() -> void:
	#space shrimp button update
	if space_check == true:
		if Space_Sand < SpaceShrimpUpgradeCost && SpaceShrimpUpgradeCost == 50000:
			$ScrollContainer/VBoxContainer/ShrimpButton.text = "Buy ???" + "\n" + NumberFormatter.format_clicker_number(SpaceShrimpUpgradeCost, 5)
			$ScrollContainer/VBoxContainer/ShrimpButton.disabled = true
			$ScrollContainer/VBoxContainer/ShrimpButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif Space_Sand >= SpaceShrimpUpgradeCost:
			$ScrollContainer/VBoxContainer/ShrimpButton.text = "Call A" + "\n" + "Space Shrimp" + "\n" + NumberFormatter.format_clicker_number(SpaceShrimpUpgradeCost, 5)
			$ScrollContainer/VBoxContainer/ShrimpButton.disabled = false
			$ScrollContainer/VBoxContainer/ShrimpButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif Space_Sand < SpaceShrimpUpgradeCost && SpaceShrimpUpgradeCost != 50000:
			$ScrollContainer/VBoxContainer/ShrimpButton.text = "Call A" + "\n" + "Space Shrimp" + "\n" + NumberFormatter.format_clicker_number(SpaceShrimpUpgradeCost, 5)
			$ScrollContainer/VBoxContainer/ShrimpButton.disabled = true
			$ScrollContainer/VBoxContainer/ShrimpButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
				
		if $ScrollContainer/VBoxContainer/ShrimpButton.disabled == false:
			$ScrollContainer/VBoxContainer/ShrimpButton.tooltip_text = "Feed them to a lurking mammal"
		
func _on_whale_button_pressed() -> void:
	if SpaceWhaleCheck != true:
		$"WhaleSprite-ko".visible = true
		SpaceWhaleCheck = true
		whale_audio.play()
	else:
		var current_scale = $"WhaleSprite-ko".scale
		current_scale.x += SpaceWhaleTweenGrowth
		current_scale.y += SpaceWhaleTweenGrowth
		var whaletween = create_tween()
		whaletween.tween_property($"WhaleSprite-ko", "scale", Vector2(current_scale), 0.5)#.from(current_scale)
		SpaceWhaleSum *= 1000
		print(str(current_scale))
	SpaceShrimpCounter = 0
	SpaceWhaleUpgradeCost += 5
	# remove the bought shrimp
	get_tree().call_group("spawned shrimp", "queue_free")
	
func _on_whale_timer_timeout() -> void:
	if space_check == true:
		if SpaceShrimpCounter >= SpaceWhaleUpgradeCost && SpaceWhaleCheck == false:
			$ScrollContainer/VBoxContainer/WhaleButton.text = "Feed The" + "\n" + "Space Whale" + "\n" + "Shrimps " + str(SpaceWhaleUpgradeCost)
			$ScrollContainer/VBoxContainer/WhaleButton.disabled = false
			$ScrollContainer/VBoxContainer/WhaleButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif SpaceShrimpCounter >= SpaceWhaleUpgradeCost && SpaceWhaleCheck == true:
			$ScrollContainer/VBoxContainer/WhaleButton.text = "Fatten The" + "\n" + "Space Whale" + "\n" + "Shrimps " + str(SpaceWhaleUpgradeCost)
			$ScrollContainer/VBoxContainer/WhaleButton.disabled = false
			$ScrollContainer/VBoxContainer/WhaleButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif SpaceShrimpCounter < SpaceWhaleUpgradeCost && SpaceWhaleCheck == true:
			$ScrollContainer/VBoxContainer/WhaleButton.text = "Fatten The" + "\n" + "Space Whale" + "\n" + "Shrimps " + str(SpaceWhaleUpgradeCost)
			$ScrollContainer/VBoxContainer/WhaleButton.disabled = true
			$ScrollContainer/VBoxContainer/WhaleButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif SpaceShrimpCounter < SpaceWhaleUpgradeCost && SpaceWhaleCheck == false:
			$ScrollContainer/VBoxContainer/WhaleButton.text = "Buy ???" + "\n" + "???"
			$ScrollContainer/VBoxContainer/WhaleButton.disabled = true
			$ScrollContainer/VBoxContainer/WhaleButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		if $ScrollContainer/VBoxContainer/WhaleButton.disabled == false:
			$ScrollContainer/VBoxContainer/WhaleButton.tooltip_text = "Increase how much Space Sand is consumed"			
			
	if SpaceWhaleCheck == true && $Background.frame == 1:
		SpaceWhaleSum = (SpaceCatUpgradeCost / 100000) * SpaceWhaleUpgradeCost
		Sand_Total_Eaten += SpaceWhaleSum
		Space_Sand += SpaceWhaleSum
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	
# the Chaos Squirrel is a gamble
func _on_squirrel_button_pressed() -> void:
	var gamble_rng := RandomNumberGenerator.new()
	gamble_rng.randomize()
	#introduce the squirrel
	if SpaceSquirrelCheck == false:
		$DozerSprite.frame = 2
		SpaceSquirrelCheck = true
		squirrel_audio.play()
		Space_Sand -= SpaceSquirrelGambleCost
		SpaceSquirrelGambleCost += 1
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	#gamble with how much you gain or lose
	else:
		Space_Sand -= SpaceSquirrelGambleCost
		SpaceSquirrelGambleCost += 500000000
		SpaceSquirrelGamble = randf_range(0.01, 1.99)
		#print(str(SpaceSquirrelGamble))
		Space_Sand *= SpaceSquirrelGamble
	
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
		#Gamble feedback
		#add sfxs
		if SpaceSquirrelGamble >= 1.01:
			good_audio.play()
			trigger_glow($DozerSprite, Color(0, 1, 0))
		else:
			bad_audio.play()
			trigger_glow($DozerSprite, Color(1, 0, 0))
			
		#spawn multiplcation		
		var pts = earned_points.instantiate()
		pts.text = "x" + NumberFormatter.format_clicker_number(SpaceSquirrelGamble, 5)
		pts.global_position.x = $DozerSprite.global_position.x 
		pts.global_position.y = $DozerSprite.global_position.y -150
		add_child(pts)
	
func _on_squirrel_timer_timeout() -> void:
	#for some reason this variable is not changing natrually from declaration
	if SpaceSquirrelGambleCost == 100000:
		SpaceSquirrelGambleCost = 1000000000

	if space_check == true:
		if SpaceSquirrelCheck == true && SpaceSquirrelGambleCost <= Space_Sand:
			$ScrollContainer/VBoxContainer/SquirrelButton.text = "Beseech The" + "\n" + "Chaos Squirrel" + "\n" + NumberFormatter.format_clicker_number(SpaceSquirrelGambleCost, 5)
			$ScrollContainer/VBoxContainer/SquirrelButton.disabled = false
			$ScrollContainer/VBoxContainer/SquirrelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif SpaceSquirrelCheck == true && SpaceSquirrelGambleCost > Space_Sand:
			$ScrollContainer/VBoxContainer/SquirrelButton.text = "Beseech The" + "\n" + "Chaos Squirrel" + "\n" + NumberFormatter.format_clicker_number(SpaceSquirrelGambleCost, 5)
			$ScrollContainer/VBoxContainer/SquirrelButton.disabled = true
			$ScrollContainer/VBoxContainer/SquirrelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		elif SpaceSquirrelCheck == false && SpaceSquirrelGambleCost <= Space_Sand:
			$ScrollContainer/VBoxContainer/SquirrelButton.text = "Call Upon" + "\n" + "Chaos Squirrel" + "\n" + NumberFormatter.format_clicker_number(SpaceSquirrelGambleCost, 5)
			$ScrollContainer/VBoxContainer/SquirrelButton.disabled = false
			$ScrollContainer/VBoxContainer/SquirrelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
		elif SpaceSquirrelCheck == false && SpaceSquirrelGambleCost > Space_Sand:
			$ScrollContainer/VBoxContainer/SquirrelButton.text = "Buy ???" + "\n" + NumberFormatter.format_clicker_number(SpaceSquirrelGambleCost, 5) 
			$ScrollContainer/VBoxContainer/SquirrelButton.disabled = true
			$ScrollContainer/VBoxContainer/SquirrelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
			
		if $ScrollContainer/VBoxContainer/SquirrelButton.disabled == false:	
			$ScrollContainer/VBoxContainer/SquirrelButton.tooltip_text = "Randomly increase or decrease your Space Sand"
		
func _on_coin_timer_timeout() -> void:
	#horse coins stop spawning in space
	if $Background.frame == 0:
		Coin_Spawn_Time = randf_range(5, 6)
		#Coin_Spawn_Time = randf_range(45, 100)
		#Coin_Spawn_Time = randf_range(100.05, 400.01)
		$CoinTimer.wait_time = Coin_Spawn_Time
	
		#adds it below Terry to put behind pause menu
		var coin = coin_scene.instantiate()
		$StaticBody2D2.add_child(coin)

# worm spawn timer
func _on_worm_timer_timeout() -> void:
	# spawns worms randomly
	Worm_Spawn_Time = randf_range(15, 22)
	$WormTimer.wait_time = Worm_Spawn_Time
	
	var worm = worm_scene.instantiate()
	$StaticBody2D2.add_child(worm)
	
func _on_worm_button_pressed() -> void:
	button_click_sfx.play()
	
	if !listItems.has("SpaceWorms"):
		listItems.append("SpaceWorm")
		SpaceWormCheck = true
		get_node("WormTimer").start()
		
	#further testing, maybe include upgrade limit
	#further test to bets reflect upgrade costs and space sand values
	Space_Sand -= SpaceWormUpgradeCost
	SpaceWormUpgradeCost *= 1.5
	Worm_Sand_Eat += Worm_Sand_Eat
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
		
# worm button timer
func _on_worm_timer_2_timeout() -> void:
	# again I have no idea why these values aren't lining up?
	if SpaceWormUpgradeCost == 5000000.0:
		SpaceWormUpgradeCost = 10000000000000
	if SpaceWormCheck == true && SpaceWormUpgradeCost <= Space_Sand:
		$ScrollContainer/VBoxContainer/WormButton.text = "Improve Potency" + "\n" + "of Space Worm" + "\n" + NumberFormatter.format_clicker_number(SpaceWormUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/WormButton.disabled = false
		$ScrollContainer/VBoxContainer/WormButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif SpaceWormCheck == true && SpaceWormUpgradeCost > Space_Sand:
		$ScrollContainer/VBoxContainer/WormButton.text = "Improve Potency" + "\n" + "of Space Worm" + "\n" + NumberFormatter.format_clicker_number(SpaceWormUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/WormButton.disabled = true
		$ScrollContainer/VBoxContainer/WormButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif SpaceWormCheck == false && SpaceWormUpgradeCost <= Space_Sand:
		$ScrollContainer/VBoxContainer/WormButton.text = "Catch A" + "\n" + "Space Worm" + "\n" + NumberFormatter.format_clicker_number(SpaceWormUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/WormButton.disabled = false
		$ScrollContainer/VBoxContainer/WormButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif SpaceWormCheck == false && SpaceWormUpgradeCost > Space_Sand:
		$ScrollContainer/VBoxContainer/WormButton.text = "Buy ???" + "\n" + NumberFormatter.format_clicker_number(SpaceWormUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/WormButton.disabled = true
		$ScrollContainer/VBoxContainer/WormButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if $ScrollContainer/VBoxContainer/WormButton.disabled == false:	
		$ScrollContainer/VBoxContainer/WormButton.tooltip_text = "Increase amount of Space Sand the Space Worm drops"

func _on_sphinx_turtle_button_pressed() -> void:
	button_click_sfx.play()
	if SpaceTurtleCheck == false:
		SpaceTurtleCheck = true
		listItems.append("SpaceFriends")
		
		Space_Sand -= SpaceTurtleUpgradeCost
		
		var animals = animals_scene.instantiate()
		$StaticBody2D2.add_child(animals)
		animals.global_position = Vector2(1076, 536)
		animals.scale = Vector2(.5, .5)
		# this line keeps it in the save (not position tho but who cares rn)
		animals.owner = get_tree().current_scene
		#maths
		SpaceTurtleUpgradeCounter += 1
		SpaceTurtleUpgradeCost *= SpaceTurtleMultiplyer
		
	if SpaceTurtleUpgradeCounter <= 10:
		Space_Sand -= SpaceTurtleUpgradeCost
		SpaceTurtleUpgradeCost *= SpaceTurtleMultiplyer
		SpaceTurtleUpgradeCounter += 1
		SpaceTurtleMultiplyer *= SpaceTurtleMultiplyer
	else:
		pass
	
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)

func _on_sphinx_turtle_timer_timeout() -> void:
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	
	if SpaceTurtleCheck == true && SpaceTurtleUpgradeCost <= Space_Sand && SpaceTurtleUpgradeCounter <= 10:
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.text = "Increase Power" + "\n" + "of Space Turtle" + "\n" + NumberFormatter.format_clicker_number(SpaceTurtleUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled = false
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif SpaceTurtleCheck == true && SpaceTurtleUpgradeCost > Space_Sand && SpaceTurtleUpgradeCounter <= 10:
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.text = "Increase Power" + "\n" + "of Space Turtle" + "\n" + NumberFormatter.format_clicker_number(SpaceTurtleUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled = true
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif SpaceTurtleCheck == false && SpaceTurtleUpgradeCost <= Space_Sand && SpaceTurtleUpgradeCounter <= 10:
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.text = "Observe the" + "\n" + "Space Rivalry" + "\n" + NumberFormatter.format_clicker_number(SpaceTurtleUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled = false
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif SpaceTurtleCheck == false && SpaceTurtleUpgradeCost > Space_Sand:
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.text = "Buy ???" + "\n" + NumberFormatter.format_clicker_number(SpaceTurtleUpgradeCost, 5)
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled = true
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif SpaceTurtleUpgradeCounter >= 11:
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.text = "Peaked Cutness"
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled = true
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if $ScrollContainer/VBoxContainer/SphinxTurtleButton.disabled == false:	
		$ScrollContainer/VBoxContainer/SphinxTurtleButton.tooltip_text = "More Space Sand gained when the Space Turtle crawls"

func _on_horror_button_pressed() -> void:
	Space_Sand = 0
	$WhaleTimer.stop()
	$WormTimer2.stop()
	$SphinxTurtleTimer.stop()

	# use get_node for names with non-identifier characters
	var horror_sprite = get_node("HorrorSpritex")
	horror_sprite.visible = true

	var horror_tween = create_tween()
	var horse_tween = create_tween()

	# start both before awaiting if you want concurrency
	horror_tween.tween_property(horror_sprite, "position", Vector2(958, 358), 5.0)
	var horse_sprite = $AnimatedHorseSprite
	horse_tween.tween_property(horse_sprite, "position", Vector2(1033, 504), 5.0)
	
	await horror_tween.finished
	await horse_tween.finished
	#print(horse_sprite.position)
	horse_sprite.set_meta("base_y", 504)# so the horse doesn't clip up after tween
	
func _on_horror_timer_timeout() -> void:

	if HorrorSummonCost <= Space_Sand:
		$ScrollContainer/VBoxContainer/HorrorButton.text = "Summon the" + "\n" + "Horror" + "\n" + NumberFormatter.format_clicker_number(HorrorSummonCost, 5)
		$ScrollContainer/VBoxContainer/HorrorButton.disabled = false
		$ScrollContainer/VBoxContainer/HorrorButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	else:
		$ScrollContainer/VBoxContainer/HorrorButton.text = "Summon ???" + "\n" + NumberFormatter.format_clicker_number(HorrorSummonCost, 5)
		$ScrollContainer/VBoxContainer/HorrorButton.disabled = true
		$ScrollContainer/VBoxContainer/HorrorButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	if $ScrollContainer/VBoxContainer/HorrorButton.disabled == false:
		$ScrollContainer/VBoxContainer/HorrorButton.tooltip_text = "Sacrifice your animals to a dark lord to transcend"

func _on_horse_timer_timeout() -> void:
	#horse only triggers on Earth
	if !$Background.frame == 1:
		Sand_Total += Horse_Sand_Eat
		Sand_Total_Eaten += Horse_Sand_Eat

		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Sand_Dollar.text = NumberFormatter.format_clicker_number(Sand_Total, 2)
	
	#updgraded golem for end game in Act 1
	if HelperGolemCheck == true:
		Sand_Total += GolemCounter * Sand
		Sand_Total_Eaten += GolemCounter * Sand

func _on_horse_col_mouse_entered() -> void:
	$AnimatedHorseSprite/HorseCol/CollisionShape2D/HorseLabel.visible = true
	$AnimatedHorseSprite/HorseCol/CollisionShape2D/HorseLabel.text = str(Horse_Sand_Eat)

func _on_horse_col_mouse_exited() -> void:
	$AnimatedHorseSprite/HorseCol/CollisionShape2D/HorseLabel.visible = false

func _on_portal_button_pressed() -> void:
	print("Portal clicked")

func _on_cheat_pressed() -> void:
	Sand_Total += 9223372036854775807
	Sand_Total_Eaten += 9223372036854775807
	var coin = coin_scene.instantiate()
	$StaticBody2D2.add_child(coin)
func _on_space_cheat_pressed() -> void:
	space_check = false
	SuperSpoonCheck = true
	SuperTrowlCheck = true
	SuperPanCheck = true
	SuperShovelCheck = true
	FCLSCheck = true
	BiggerDozerCheck = true
	HorseCheck = true
	Sand_Total_Eaten = 9223372036854775807
	
func _on_space_cheat_2_pressed() -> void:
	Space_Sand += 9223372036854775807
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	
func stop_act1_timers():
	$SpoonTimer.stop()
	$TrowlTimer.stop()
	$PanTimer.stop()
	$ShovelTimer.stop()
	$CLSTimer.stop()
	$DozerTimer.stop()
	$GolemTimer.stop()
	
# loading save stops timers for some reason
func start_timers():
	get_node("AutoSaveTimer").autostart = true
	Coin_Spawn_Time = randf_range(5, 6)
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
		get_node("ShrimpTimer").start()
		get_node("WhaleTimer").start()
		get_node("SquirrelTimer").start()
		get_node("WormTimer2").start()
		get_node("SphinxTurtleTimer").start()
		get_node("HorrorTimer").start()
		if listItems.has("SpaceCat"):
			get_node("CatQTETimer").start()
			#$CatQTETimer.start()
		if listItems.has("SpaceWorm"):
			get_node("WormTimer").start()

func _on_auto_save_timer_timeout() -> void:
	#print("Game saved teehee")
	var root = get_tree().current_scene
	var scene = PackedScene.new()
	scene.pack(root)
	ResourceSaver.save(scene, "user://SavedGame.tscn")
	
	# doubling the use of this timer to check for scene transition into space
	if (!space_check && SuperSpoonCheck && SuperTrowlCheck && SuperPanCheck && SuperShovelCheck && FCLSCheck && BiggerDozerCheck && HorseCheck && Sand_Total_Eaten >= 9223372000000000000):
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
			$Sand_Mult.text = "Consumption Rate: 0×"
			$Space_Sand_Ate.text = "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][wave]Space Sand: 0"
			$Space_Sand_Ate.visible = true

# picking and spawning the letters on Space Cat, also setting the range of wait time
func _on_cat_qte_timer_timeout() -> void:
	if QTE == null:
		print("QTE PackedScene is null"); return
	if keyList == null or keyList.size() == 0:
		print("keyList empty"); $CatQTETimer.wait_time = randf_range(SC_Check_Min, SC_Check_Max); return

	# only spawn if no active key
	if active_key_node != null:
		$CatQTETimer.wait_time = randf_range(SC_Check_Min, SC_Check_Max)
		return

	var keyData = keyList.pick_random()
	var keyNode = QTE.instantiate()
	if keyNode == null:
		print("instantiate returned null"); return

	# set data and connect once
	keyNode.keyCode = keyData.keyCode
	keyNode.keyString = keyData.keyString
	keyNode.finished.connect(_on_key_finished)
	keyNode.qte_success.connect(_on_qte_success)
	keyNode.qte_failure.connect(_on_ate_fail)

	var container = $CanvasLayer.get_node_or_null("ControlContainer")
	if container == null:
		print("ControlContainer missing"); return

	container.add_child(keyNode)
	active_key_node = keyNode
	key_count += 1
	$CatQTETimer.wait_time = randf_range(SC_Check_Min, SC_Check_Max)
	
func _on_key_finished(keySuc):
	if active_key_node != null and is_instance_valid(active_key_node):
		active_key_node.queue_free() # if you want to remove
	active_key_node = null
	keyPressedList.append(keySuc)
	# if the signal provides the node instance instead of data, adjust accordingly.
	if active_key_node != null:
		active_key_node.queue_free()
	active_key_node = null
	
#success on the cat qte
func _on_qte_success(amount_Space_Sand):
	#print("got me right")
	trigger_glow($"CatSprite-o", Color(0, 1, 0))
	if SpaceCatCounter <= 1:
		SpaceCatCounter = 2
	else:
		SpaceCatCounter = SpaceCatCounter * 2
	var sp_gained = (amount_Space_Sand * SpaceCatCounter) / 2
	Space_Sand += sp_gained
	$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
	$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	#print("Space Cat Counter is " + str(SpaceCatCounter))
	#print("Space Sand is at " + str(Space_Sand) + " by being x by " + str(amount_Space_Sand))
	
	#spawn multiplcation		
	var pts = earned_points.instantiate()
	pts.text = "+" + NumberFormatter.format_clicker_number(sp_gained, 5)
	pts.global_position.x = $"CatSprite-o".global_position.x 
	pts.global_position.y = $"CatSprite-o".global_position.y - 100
	add_child(pts)
#failure on the cat qte
func _on_ate_fail(amount_Space_Sand):
	if SpaceCatCounter >= 2 && Space_Sand >= 2:
		trigger_glow($"CatSprite-o", Color(1, 0, 0))
		#print("got me wrong")
		#print("Space Cat Counter is " + str(SpaceCatCounter) + " / by 2")
		@warning_ignore("integer_division")
		SpaceCatCounter = SpaceCatCounter / amount_Space_Sand
		#Space_Sand = Space_Sand / SpaceCatCounter
		#print("Space Sand is at " + str(Space_Sand) + " by " + str(Space_Sand) + " being / by " + str(SpaceCatCounter))
		$Sand_Ate.text = NumberFormatter.format_clicker_number(Sand_Total_Eaten, 1)
		$Space_Sand_Ate.text = NumberFormatter.format_clicker_number(Space_Sand, 4)
	else:
		pass
		
func trigger_glow(sprite: AnimatedSprite2D, color: Color, strength: float = 75.5, duration: float = 0.5):
	# Set color
	sprite.material.set("shader_parameter/glow_color", color)
	
	#Start strong
	sprite.material.set("shader_parameter/glow_strength", strength)

	#fades out smoothly
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/glow_strength",	0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
