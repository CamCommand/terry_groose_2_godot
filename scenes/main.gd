@tool
extends Node2D

@export var Sand: float = 1
@export var Sand_Total: float = 0
@export var Sand_Total_Eaten: float = 0
var next_input: bool = false
@export var s_label: String
@export var s_label_d: String

var coin_scene: PackedScene = load("res://scenes/horse_coin.tscn")

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool

@export var TrowlUpgradeCost: float = 100
@export var TrowlCounter: float
@export var TrowlCheck: bool
@export var SuperTrowlCheck: bool

@export var PanUpgradeCost: float = 100
@export var PanCounter: float
@export var PanCheck: bool
@export var SuperPanCheck: bool

#@onready var Spoon_Button Button = $Spoon_Button

@export var listItems: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten) + " .lbs"
	$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
	
func _process(delta: float) -> void:

	if $Sand_Ate.text == "":
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"

	if $Sand_Dollar.text == "":
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))

	if Input.is_action_just_pressed("ui_left") && next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		
		next_input = true
	
	if Input.is_action_just_pressed("ui_right") && next_input == true:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		
		next_input = false

func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	if Sand_Total >= 100 && !listItems.has("Spoon"):
		$SpoonButton.text = "Buy Spoon " + "\n" + str(SpoonUpgradeCost)
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
		$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(SpoonUpgradeCost)
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && SpoonCounter == 11:
		$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(SpoonUpgradeCost)
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	

func _on_spoon_button_pressed() -> void:
	#$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter < 11:
		Sand_Total -= SpoonUpgradeCost
		SpoonCounter += 1
		
	#multiplyer for bigger upgrades
		if SpoonCounter == 11:
			SpoonUpgradeCost = SpoonUpgradeCost * 2.5
			$SpoonButton.text = "Buy " + "\n" + "Super Spoon " + "\n" +  str(SpoonUpgradeCost)
		else:
			SpoonUpgradeCost = SpoonUpgradeCost + (100 * SpoonCounter)
			$SpoonButton.text = "Upgrade Spoon " + "\n" + str(SpoonUpgradeCost)

		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.1
		
	elif SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		listItems.append("Super Spoon")		
		SuperSpoonCheck = true
		SpoonCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.3
		SpoonUpgradeCost = SpoonUpgradeCost + (200 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + str(SpoonUpgradeCost)
	
	elif SuperSpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter > 11:
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.35
		SpoonUpgradeCost = SpoonUpgradeCost + (200 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade" + "\n" + " Super Spoon "  + "\n" + str(SpoonUpgradeCost)

	if Sand_Total >= 100 && SpoonCheck == false && SuperSpoonCheck == false:
		Sand_Total -= 100
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		
		listItems.append("Spoon")
		SpoonCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.1
		SpoonUpgradeCost = 200
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade Spoon " + "\n" + str(SpoonUpgradeCost)
		
	#SandModLabel.Text = "Sand Eatting Modifier: " & Math.Round(Sand, 2)

func _on_trowl_button_pressed() -> void:
	#$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter < 11:
		Sand_Total -= TrowlUpgradeCost
		TrowlCounter += 1
		
	#multiplyer for bigger upgrades
		if TrowlCounter == 11:
			TrowlUpgradeCost = TrowlUpgradeCost * 2.5
			$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(TrowlUpgradeCost)
		else:
			TrowlUpgradeCost = TrowlUpgradeCost + (150 * TrowlCounter)
			$TrowlButton.text = "Upgrade Trowl " +"\n" + str(TrowlUpgradeCost)

		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.2
		
	elif TrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		listItems.append("Super Trowl")		
		SuperTrowlCheck = true
		TrowlCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.4
		TrowlUpgradeCost = TrowlUpgradeCost + (200 * TrowlCounter)
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + str(TrowlUpgradeCost)
	
	elif SuperTrowlCheck == true && Sand_Total >= TrowlUpgradeCost && TrowlCounter > 11:
		Sand_Total -= TrowlUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.25
		TrowlUpgradeCost = TrowlUpgradeCost + (200 * TrowlCounter)
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade " + "\n" + "Super Trowl " + "\n" + str(TrowlUpgradeCost)

	if Sand_Total >= 1000 && TrowlCheck == false && SuperTrowlCheck == false:
		Sand_Total -= 1000
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		
		listItems.append("Trowl")
		TrowlCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.2
		TrowlUpgradeCost = 2000
		TrowlCounter += 1
		$TrowlButton.text = "Upgrade Trowl " +"\n" + str(TrowlUpgradeCost)
		
	#SandModLabel.Text = "Sand Eatting Modifier: " & Math.Round(Sand, 2)

func _on_trowl_timer_timeout() -> void:
# checking and setting Trowl Button conditions
	if Sand_Total >= 1000 && !listItems.has("Trowl"):
		$TrowlButton.text = "Buy Trowl " + "\n" + str(TrowlUpgradeCost)
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < 100 && !listItems.has("Trowl"):
		$TrowlButton.disabled = true
		$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost:
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost:
		$TrowlButton.disabled = true
		$TrowlButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
		
	if listItems.has("Trowl") && Sand_Total >= TrowlUpgradeCost && TrowlCounter == 11:
		$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(TrowlUpgradeCost)
		$TrowlButton.disabled = false
		$TrowlButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < TrowlUpgradeCost && TrowlCounter == 11:
		$TrowlButton.text = "Buy " + "\n" + "Super Trowl " + "\n" + str(TrowlUpgradeCost)
		$TrowlButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	

func _on_pan_button_pressed() -> void:
#$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter < 11:
		Sand_Total -= PanUpgradeCost
		PanCounter += 1
		
	#multiplyer for bigger upgrades
		if PanCounter == 11:
			PanUpgradeCost = PanUpgradeCost * 2.5
			$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" + str(PanUpgradeCost)
		else:
			PanUpgradeCost = PanUpgradeCost + (200 * PanCounter)
			$PanButton.text = "Upgrade Pan " +"\n" + str(PanUpgradeCost)

		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.2
		
	elif PanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter == 11:
		listItems.append("Super Pan")		
		SuperPanCheck = true
		PanCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.6
		PanUpgradeCost = PanUpgradeCost + (200 * PanCounter)
		PanCounter += 1
		$PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + str(PanUpgradeCost)
	
	elif SuperPanCheck == true && Sand_Total >= PanUpgradeCost && PanCounter > 11:
		Sand_Total -= PanUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		Sand = Sand * 1.35
		PanUpgradeCost = PanUpgradeCost + (400 * PanCounter)
		PanCounter += 1
		$PanButton.text = "Upgrade " + "\n" + "Super Pan " + "\n" + str(PanUpgradeCost)

	if Sand_Total >= 3000 && PanCheck == false && SuperPanCheck == false:
		Sand_Total -= 3000
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(round(Sand_Total))
		
		listItems.append("Pan")
		PanCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.3
		PanUpgradeCost = 4000
		PanCounter += 1
		$PanButton.text = "Upgrade Pan " +"\n" + str(PanUpgradeCost)

func _on_pan_timer_timeout() -> void:
# checking and setting Pan Button conditions
	if Sand_Total >= 3000 && !listItems.has("Pan"):
		$PanButton.text = "Buy Pan " + "\n" + str(PanUpgradeCost)
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
		$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  str(PanUpgradeCost)
		$PanButton.disabled = false
		$PanButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < PanUpgradeCost && PanCounter == 11:
		$PanButton.text = "Buy " + "\n" + "Super Pan " + "\n" +  str(PanUpgradeCost)
		$PanButton.disabled = true
		$PanButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	
func _on_coin_timer_timeout() -> void:
	var coin = coin_scene.instantiate()
	add_child(coin)
