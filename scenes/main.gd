@tool
extends Node2D

@export var Sand: float = 1
@export var Sand_Total: float = 98
@export var Sand_Total_Eaten: float = 98
var next_input: bool = false
@export var s_label: String
@export var s_label_d: String

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool

#@onready var Spoon_Button: Button = $Spoon_Button

@export var listItems: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten) + " .lbs"
	$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
	
func _process(delta: float) -> void:

	if $Sand_Ate.text == "":
		$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten)+ " .lbs"

	if $Sand_Dollar.text == "":
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)

	if Input.is_action_just_pressed("left") && next_input == false:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten)+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		
		next_input = true
	
	if Input.is_action_just_pressed("right") && next_input == true:
		Sand_Total += Sand
		Sand_Total_Eaten += Sand
		
		$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten)+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		
		next_input = false




func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	#if Sand_Total >= 100 && !listItems.has("Spoon"):
		#$SpoonButton.disabled = false
		#$SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	#elif Sand_Total < 100 && !listItems.has("Spoon"):
		#$SpoonButton.disabled = true
		#$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		#
	#if listItems.has("Spoon") && Sand_Total >= 100:
		#$SpoonButton.text = "Spoon Upgrade:" + "\n"  + str(SpoonUpgradeCost)
	#else:
		#$SpoonButton.text = "Buy Spoon:" + "\n"  + "100"
	if Sand_Total >= 100 && !listItems.has("Spoon"):
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
		$SpoonButton.text = "Buy Super Spoon:" + "\n"  + str(SpoonUpgradeCost)
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.812, 0.145, 0.0, 1.0)
	elif Sand_Total < SpoonUpgradeCost && SpoonCounter == 11:
		$SpoonButton.text = "Buy Super Spoon:" + "\n"  + str(SpoonUpgradeCost)
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)	


func _on_spoon_button_pressed() -> void:
	print(Sand_Total)
	print(SpoonCheck)
	print(SpoonCounter)
	$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter < 11:
		Sand_Total -= SpoonUpgradeCost
		SpoonCounter += 1
		
	#multiplyer for bigger upgrades
		if SpoonCounter == 11:
			SpoonUpgradeCost = SpoonUpgradeCost * 2.5
			$SpoonButton.text = "Buy Super Spoon: " + str(SpoonUpgradeCost)
		else:
			SpoonUpgradeCost = SpoonUpgradeCost + (100 * SpoonCounter)
			$SpoonButton.text = "Upgrade Spoon: " + str(SpoonUpgradeCost)

		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		Sand = Sand * 1.1
		
	elif SpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter == 11:
		listItems.append("Super Spoon")		
		SuperSpoonCheck = true
		SpoonCheck = false	
		
		#add on screen text and or menu to display items here
		
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten)+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		Sand = Sand * 1.3
		SpoonUpgradeCost = SpoonUpgradeCost + (200 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade Super Spoon: " + str(SpoonUpgradeCost)
	
	elif SuperSpoonCheck == true && Sand_Total >= SpoonUpgradeCost && SpoonCounter > 11:
		Sand_Total -= SpoonUpgradeCost
		$Sand_Ate.text = "Sand Ate: " + str(Sand_Total_Eaten)+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		Sand = Sand * 1.35
		SpoonUpgradeCost = SpoonUpgradeCost + (200 * SpoonCounter)
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade Super Spoon: " + str(SpoonUpgradeCost)

	if Sand_Total >= 100 && SpoonCheck == false && SuperSpoonCheck == false:
		Sand_Total -= 100
		$Sand_Ate.text = "Sand Ate: " + str(round(Sand_Total_Eaten))+ " .lbs"
		$Sand_Dollar.text = "Sand Dollars: $" + str(Sand_Total)
		
		listItems.append("Spoon")
		SpoonCheck = true
		
		# update text with list of items here
		Sand = Sand * 1.1
		SpoonUpgradeCost = 200
		SpoonCounter += 1
		$SpoonButton.text = "Upgrade Spoon: " + str(SpoonUpgradeCost)
		
	#SandModLabel.Text = "Sand Eatting Modifier: " & Math.Round(Sand, 2)
