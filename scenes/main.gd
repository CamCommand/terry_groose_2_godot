@tool
extends Node2D

@export var Sand: float = 1
@export var Sand_Total: float 
@export var Sand_Total_Eaten: float 
var next_input: bool = false
@export var s_label: String
@export var s_label_d: String

var coin_scene: PackedScene = load("res://scenes/horse_coin.tscn")

@onready var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool

@onready var TrowlUpgradeCost: float = 1000
@export var TrowlCounter: float
@export var TrowlCheck: bool
@export var SuperTrowlCheck: bool

@onready var PanUpgradeCost: float = 3000
@export var PanCounter: float
@export var PanCheck: bool
@export var SuperPanCheck: bool

@onready var ShovelUpgradeCost: float = 10000
@export var ShovelCounter: float
@export var ShovelCheck: bool
@export var SuperShovelCheck: bool

@onready var CLSUpgradeCost: float = 100000
@export var CLSCounter: float
@export var CLSCheck: bool
@export var FCLSCheck: bool

@onready var DozerUpgradeCost: float = 1000000
@export var DozerCounter: float
@export var DozerCheck: bool
@export var BiggerDozerCheck: bool

@export var listItems: Array = []
@export var Coin_Spawn_Time: float 

var Horse_Sand_Eat: int
var HorseCheck: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Sand_Total = 0
	Sand_Total_Eaten = 0
	
	$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
	$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
	
func auto_input():
	if next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Input.action_press("ui_left")
		#print(1)
		next_input = true
	else:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Input.action_press("ui_right")
		#print(2)
		next_input = false
		
func _process(delta: float) -> void:
	
	if $Sand_Ate.text == "":
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"

	if $Sand_Dollar.text == "":
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
	
	#auto_input()
	
	if  Input.is_action_just_pressed("ui_left") && next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		next_input = true
	
	if Input.is_action_just_pressed("ui_right") && next_input == true:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		next_input = false
	
	
	# code to change color of Sand_Ate label based on how much sand you ate	
	#match Sand_Total_Eaten:
		#Sand_Total_Eaten when Sand_Total_Eaten >= 10 && Sand_Total_Eaten < 20:
			#$Sand_Ate.add_theme_color_override("font_color", Color.hex(12))
		#Sand_Total_Eaten when Sand_Total_Eaten >= 20:
			#$Sand_Ate.add_theme_color_override("font_color", Color.DARK_BLUE)
			
func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	if Sand_Total >= 100 && !listItems.has("Spoon"):
		$SpoonButton.text = "Buy Spoon " + "\n" + str(int(SpoonUpgradeCost))
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 100 && !listItems.has("Spoon"):
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost:
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost:
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Spoon") && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(int(SpoonUpgradeCost))
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && SpoonCounter == 11:
		$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(int(SpoonUpgradeCost))
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
			
	elif SuperSpoonCheck == true && SpoonCounter == 21:
		$SpoonButton.text = "Max Spoon" + "\n" + " Reached"
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_spoon_button_pressed() -> void:
	#$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter < 11:
		Sand_Total -= SpoonUpgradeCost
		SpoonCounter += 1
		
	#multiplyer for bigger upgrades
		if SpoonCounter == 11:
			SpoonUpgradeCost = SpoonUpgradeCost * 2.5
			$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(int(SpoonUpgradeCost))
		else:
			SpoonUpgradeCost = SpoonUpgradeCost + (100 * SpoonCounter)
			$SpoonButton.text = "Upgrade Spoon " + "\n" + str(int(SpoonUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.1
		
	elif SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		listItems.append("Super Spoon")		
		SuperSpoonCheck = true
		SpoonCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.3
		SpoonUpgradeCost = SpoonUpgradeCost + (400 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + str(int(SpoonUpgradeCost))
	
	elif SuperSpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter > 11:
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.35
		SpoonUpgradeCost = SpoonUpgradeCost + (400 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + str(int(SpoonUpgradeCost))

	if Sand_Total >= 100 && SpoonCheck == false && SuperSpoonCheck == false:
		Sand_Total -= 100
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Spoon")
		SpoonCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.1
		SpoonUpgradeCost = 200
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade Spoon " + "\n" + str(int(SpoonUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))
	
func _on_trowl_button_pressed() -> void:
	#$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter < 11:
		Sand_Total -= TrowlUpgradeCost
		TrowlCounter += 1
		
	#multiplyer for bigger upgrades
		if TrowlCounter == 11:
			TrowlUpgradeCost = TrowlUpgradeCost * 2.5
			$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(int(TrowlUpgradeCost))
		else:
			TrowlUpgradeCost = TrowlUpgradeCost + (150 * TrowlCounter)
			$TrowlButton.text = "Upgrade Trowl " +"\n" + str(int(TrowlUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.2
		
	elif TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		listItems.append("Super Trowl")		
		SuperTrowlCheck = true
		TrowlCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.4
		TrowlUpgradeCost = TrowlUpgradeCost + (800 * TrowlCounter)
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + str(int(TrowlUpgradeCost))
	
	elif SuperTrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter > 11:
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.25
		TrowlUpgradeCost = TrowlUpgradeCost + (800 * TrowlCounter)
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + str(int(TrowlUpgradeCost))

	if Sand_Total >= 1000 && TrowlCheck == false && SuperTrowlCheck == false:
		Sand_Total -= 1000
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Trowl")
		TrowlCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.2
		TrowlUpgradeCost = 2000
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade Trowl " +"\n" + str(int(TrowlUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))

func _on_trowl_timer_timeout() -> void:
# checking and setting Trowl Button conditions
	if Sand_Total >= 1000 && !listItems.has("Trowl"):
		$TrowlButton.text = "Buy Trowl " + "\n" + str(int(TrowlUpgradeCost))
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 1000 && !listItems.has("Trowl"):
		$TrowlButton.disabled = true
		$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost:
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost:
		$TrowlButton.disabled = true
		$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(int(TrowlUpgradeCost))
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost && TrowlCounter == 11:
		$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(int(TrowlUpgradeCost))
		$TrowlButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperTrowlCheck == true && TrowlCounter == 26:
		$TrowlButton.text = "Max Trowl" + "\n" + " Reached"
		$TrowlButton.disabled = true
		$TrowlButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_pan_button_pressed() -> void:
#$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter < 11:
		Sand_Total -= PanUpgradeCost
		PanCounter += 1
		
	#multiplyer for bigger upgrades
		if PanCounter == 11:
			PanUpgradeCost = PanUpgradeCost * 2.5
			$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + str(int(PanUpgradeCost))
		else:
			PanUpgradeCost = PanUpgradeCost + (200 * PanCounter)
			$PanButton.text = "Upgrade Pan " +"\n" + str(int(PanUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.2
		
	elif PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		listItems.append("Super Pan")		
		SuperPanCheck = true
		PanCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.6
		PanUpgradeCost = PanUpgradeCost + (1000 * PanCounter)
		PanCounter += 1
		$PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + str(int(PanUpgradeCost))
	
	elif SuperPanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter > 11:
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.35
		PanUpgradeCost = PanUpgradeCost + (1000 * PanCounter)
		PanCounter += 1
		$PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + str(int(PanUpgradeCost))

	if Sand_Total >= 3000 && PanCheck == false && SuperPanCheck == false:
		Sand_Total -= 3000
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Pan")
		PanCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.3
		PanUpgradeCost = 4000
		PanCounter += 1
		$PanButton.text = "Upgrade Pan " +"\n" + str(int(PanUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))

func _on_pan_timer_timeout() -> void:
# checking and setting Pan Button conditions
	if Sand_Total >= 3000 && !listItems.has("Pan"):
		$PanButton.text = "Buy Pan " + "\n" + str(int(PanUpgradeCost))
		$PanButton.disabled = false
		$PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 3000 && !listItems.has("Pan"):
		$PanButton.disabled = true
		$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost:
		$PanButton.disabled = false
		$PanButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost:
		$PanButton.disabled = true
		$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Pan") && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  str(int(PanUpgradeCost))
		$PanButton.disabled = false
		$PanButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost && PanCounter == 11:
		$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  str(int(PanUpgradeCost))
		$PanButton.disabled = true
		$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperPanCheck == true && PanCounter == 31:
		$PanButton.text = "Max Pan" + "\n" + " Reached"
		$PanButton.disabled = true
		$PanButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_shovel_timer_timeout() -> void:
# checking and setting Shovel Button conditions
	if Sand_Total >= 10000 && !listItems.has("Shovel"):
		$ShovelButton.text = "Buy Shovel " + "\n" + str(int(ShovelUpgradeCost))
		$ShovelButton.disabled = false
		$ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 10000 && !listItems.has("Shovel"):
		$ShovelButton.disabled = true
		$ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost:
		$ShovelButton.disabled = false
		$ShovelButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost:
		$ShovelButton.disabled = true
		$ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Shovel") && Sand_Total >= ShovelUpgradeCost && ShovelCounter == 11:
		$ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" +  str(int(ShovelUpgradeCost))
		$ShovelButton.disabled = false
		$ShovelButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < ShovelUpgradeCost && ShovelCounter == 11:
		$ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" +  str(int(ShovelUpgradeCost))
		$ShovelButton.disabled = true
		$ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif SuperShovelCheck == true && ShovelCounter == 36:
		$ShovelButton.text = "Max Shovel" + "\n" + " Reached"
		$ShovelButton.disabled = true
		$ShovelButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_shovel_button_pressed() -> void:
#$ShovelButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if ShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter < 11:
		Sand_Total -= ShovelUpgradeCost
		ShovelCounter += 1
		
	#multiplyer for bigger upgrades
		if ShovelCounter == 11:
			ShovelUpgradeCost = ShovelUpgradeCost * 2.5
			$ShovelButton.text = "Buy " + "\n" + "Super Shovel " + "\n" + str(int(ShovelUpgradeCost))
		else:
			ShovelUpgradeCost = ShovelUpgradeCost + (600 * ShovelCounter)
			$ShovelButton.text = "Upgrade Shovel " +"\n" + str(int(ShovelUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.3
		
	elif ShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter == 11:
		listItems.append("Super Shovel")		
		SuperShovelCheck = true
		ShovelCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= ShovelUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.8
		ShovelUpgradeCost = ShovelUpgradeCost + (1400 * ShovelCounter)
		ShovelCounter += 1
		$ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + str(int(ShovelUpgradeCost))
	
	elif SuperShovelCheck == true && Sand_Total >= ShovelUpgradeCost && ShovelCounter > 11:
		Sand_Total -= ShovelUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.55
		ShovelUpgradeCost = ShovelUpgradeCost + (1400 * ShovelCounter)
		ShovelCounter += 1
		$ShovelButton.text = "Upgrade " + "\n" + "Super Shovel " + "\n" + str(int(ShovelUpgradeCost))

	if Sand_Total >= 10000 && ShovelCheck == false && SuperShovelCheck == false:
		Sand_Total -= 10000
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Shovel")
		ShovelCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.5
		ShovelUpgradeCost = 20000
		ShovelCounter += 1
		$ShovelButton.text = "Upgrade Shovel " +"\n" + str(int(ShovelUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))

func _on_cls_timer_timeout() -> void:
# checking and setting Comically Large SPOON Button conditions
	if Sand_Total >= 100000 && !listItems.has("Comically Large SPOON"):
		$CLSButton.text = "Buy Comically " + "\n" + " Large SPOON " + "\n" + str(int(CLSUpgradeCost))
		$CLSButton.disabled = false
		$CLSButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 100000 && !listItems.has("Comically Large SPOON"):
		$CLSButton.disabled = true
		$CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost:
		$CLSButton.disabled = false
		$CLSButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost:
		$CLSButton.disabled = true
		$CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Comically Large SPOON") && Sand_Total >= CLSUpgradeCost && CLSCounter == 11:
		$CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + str(int(CLSUpgradeCost))
		$CLSButton.disabled = false
		$CLSButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < CLSUpgradeCost && CLSCounter == 11:
		$CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + str(int(CLSUpgradeCost))
		$CLSButton.disabled = true
		$CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif FCLSCheck == true && CLSCounter == 50:
		$CLSButton.text = "Max Spoonage" + "\n" + " Reached"
		$CLSButton.disabled = true
		$CLSButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	

func _on_cls_button_pressed() -> void:
#$CLSButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if CLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter < 11:
		Sand_Total -= CLSUpgradeCost
		CLSCounter += 1
		
	#multiplyer for bigger upgrades
		if CLSCounter == 11:
			CLSUpgradeCost = CLSUpgradeCost * 2.5
			$CLSButton.text = "Buy Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + str(int(CLSUpgradeCost))
		else:
			CLSUpgradeCost = CLSUpgradeCost + (550 * CLSCounter)
			$CLSButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + str(int(CLSUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.4
		
	elif CLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter == 11:
		listItems.append("Funnier Comically Large SPOON")		
		FCLSCheck = true
		CLSCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= CLSUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.8
		CLSUpgradeCost = CLSUpgradeCost + (10000 * CLSCounter)
		CLSCounter += 1
		$CLSButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + str(int(CLSUpgradeCost))
	
	elif FCLSCheck == true && Sand_Total >= CLSUpgradeCost && CLSCounter > 11:
		Sand_Total -= CLSUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 1.75
		CLSUpgradeCost = CLSUpgradeCost + (10000 * CLSCounter)
		CLSCounter += 1
		$CLSButton.text = "Upgrade Funnier " + "\n" + "Comically Large" + "\n" + " SPOON " + "\n" + str(int(CLSUpgradeCost))

	if Sand_Total >= 100000 && CLSCheck == false && FCLSCheck == false:
		Sand_Total -= 100000
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Comically Large SPOON")
		CLSCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.8
		CLSUpgradeCost = 200000
		CLSCounter += 1
		$CLSButton.text = "Upgrade Comically " + "\n" + " Large SPOON " + "\n" + str(int(CLSUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))
	
	
func _on_dozer_timer_timeout() -> void:
# checking and setting Dozer Button conditions
	if Sand_Total >= 1000000 && !listItems.has("Dozer"):
		$DozerButton.text = "Buy Dozer" + "\n" + str(int(DozerUpgradeCost))
		$DozerButton.disabled = false
		$DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 1000000 && !listItems.has("Dozer"):
		$DozerButton.disabled = true
		$DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost:
		$DozerButton.disabled = false
		$DozerButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost:
		$DozerButton.disabled = true
		$DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Dozer") && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		$DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + str(int(DozerUpgradeCost))
		$DozerButton.disabled = false
		$DozerButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < DozerUpgradeCost && DozerCounter == 11:
		$DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + str(int(DozerUpgradeCost))
		$DozerButton.disabled = true
		$DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	elif BiggerDozerCheck == true && DozerCounter == 100:
		$DozerButton.text = "Final Dozer" + "\n" + " Reached"
		$DozerButton.disabled = true
		$DozerButton.modulate = Color(0.0, 0.0, 0.0, 1.0)	
	
func _on_dozer_button_pressed() -> void:
#$DozerButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter < 11:
		Sand_Total -= DozerUpgradeCost
		DozerCounter += 1
		
	#multiplyer for bigger upgrades
		if DozerCounter == 11:
			DozerUpgradeCost = DozerUpgradeCost * 5
			$DozerButton.text = "Buy Bigger " + "\n" + "Dozer" + "\n" + str(int(DozerUpgradeCost))
		else:
			DozerUpgradeCost = DozerUpgradeCost + (1000 * DozerCounter)
			$DozerButton.text = "Upgrade Dozer " + "\n" + str(int(DozerUpgradeCost))

		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 2
		
	elif DozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter == 11:
		listItems.append("Bigger Dozer")		
		BiggerDozerCheck = true
		DozerCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 2
		DozerUpgradeCost = DozerUpgradeCost + (100000 * DozerCounter)
		DozerCounter += 1
		$DozerButton.text = "Upgrade Bigger" + "\n" + "Dozer" + "\n" + str(int(DozerUpgradeCost))
	
	elif BiggerDozerCheck == true && Sand_Total >= DozerUpgradeCost && DozerCounter > 11:
		Sand_Total -= DozerUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		Sand = Sand * 2.25
		DozerUpgradeCost = DozerUpgradeCost + (100000 * DozerCounter)
		DozerCounter += 1
		$DozerButton.text = "Upgrade Bigger " + "\n" + "Dozer" + "\n" + str(int(DozerUpgradeCost))

	if Sand_Total >= 1000000 && DozerCheck == false && BiggerDozerCheck == false:
		Sand_Total -= 1000000
		$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01))+ ".lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
		
		listItems.append("Dozer")
		DozerCheck = true
		
		# update text with list of items here
		Sand = Sand * 2
		DozerUpgradeCost = 2000000
		DozerCounter += 1
		$DozerButton.text = "Upgrade Dozer " + "\n" + str(int(CLSUpgradeCost))
		
	$Sand_Mult.text = "Consumption Rate: " + str(snapped(Sand, 0.01))
	
func _on_coin_timer_timeout() -> void:
	# random coin drop time
	var coin_drop:= RandomNumberGenerator.new()
	randomize()
	#Coin_Spawn_Time = randf_range(150.05, 300.05)
	#Coin_Spawn_Time = randf_range(1, 2)
	Coin_Spawn_Time = randf_range(5, 8)
	#Coin_Spawn_Time = randf_range(100.05, 400.01)
	$CoinTimer.wait_time = Coin_Spawn_Time
	print($CoinTimer.wait_time)
	
	var coin = coin_scene.instantiate()
	add_child(coin)
	

func _on_horse_timer_timeout() -> void:
	Sand_Total += Horse_Sand_Eat
	Sand_Total_Eaten += Horse_Sand_Eat

	$Sand_Ate.text = "Sand Ate: " + str(snapped(Sand_Total_Eaten, 0.01)) + ".lbs"
	$Sand_Dollar.text = "Sand Dollars: $" + str(snapped(Sand_Total, 0.01))
