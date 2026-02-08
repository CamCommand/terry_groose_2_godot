@tool
extends Node2D

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool

@onready var Sand_Eatten_Label: Label = $Sand_Eatten_Label
@onready var Sand_Dollar_Label: Label = $Sand_Dollar_Label

#@onready var Spoon_Button: Button = $Spoon_Button

@export var listItems: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sand_Eatten_Label.text = "Sand Eatten: "
	Sand_Dollar_Label.text = "Sand Dollars: "
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Player_Vars.s_label == "":
		Sand_Eatten_Label.text = "Sand Eatten:"
	else:
		Sand_Eatten_Label.text = Player_Vars.s_label
		
	if Player_Vars.s_label_d == "":
		Sand_Dollar_Label.text = "Sand Dollars:"
	else:
		Sand_Dollar_Label.text = Player_Vars.s_label_d


func _on_button_pressed() -> void:
	if SpoonCheck == true && Player_Vars.Sand_Total_Eatten >= SpoonUpgradeCost && SpoonCounter < 11:
		Player_Vars.Sand_Total_Eatten -= SpoonUpgradeCost
		
		# sets the label text on button press
		Sand_Eatten_Label.text = "Sand Eatten: " + str(Player_Vars.Sand_Total) + " .lbs"
		Player_Vars.s_label = Sand_Eatten_Label.text
		Sand_Dollar_Label.text = "Sand Dollars: $" + str(Player_Vars.Sand_Total_Eatten)
		Player_Vars.s_label_d = Sand_Dollar_Label.text
		
	else:
		$SpoonButton.text = "Buy Spoon:" + "\n"  + "100"
		Player_Vars.Sand_Total_Eatten -= SpoonUpgradeCost
		SpoonCheck = true
		Player_Vars.Sand = Player_Vars.Sand * 1.1
		listItems.append("Spoon")
		
		# sets the label text on button press
		Sand_Eatten_Label.text = "Sand Eatten: " + str(Player_Vars.Sand_Total) + " .lbs"
		Player_Vars.s_label = Sand_Eatten_Label.text
		Sand_Dollar_Label.text = "Sand Dollars: $" + str(Player_Vars.Sand_Total_Eatten)
		Player_Vars.s_label_d = Sand_Dollar_Label.text

func _on_spoon_timer_timeout() -> void:
	# checking and setting Spoon Button conditions
	if Player_Vars.Sand_Total >= 100 && !listItems.has("Spoon"):
		$SpoonButton.disabled = false
		$SpoonButton.modulate = Color(0.825, 0.741, 0.0, 1.0)
	elif Player_Vars.Sand_Total < 100 && !listItems.has("Spoon"):
		$SpoonButton.disabled = true
		$SpoonButton.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if listItems.has("Spoon") && Player_Vars.Sand_Total >= 100:
		$SpoonButton.text = "Spoon Upgrade:" + "\n"  + str(SpoonUpgradeCost)
	else:
		$SpoonButton.text = "Buy Spoon:" + "\n"  + "100"
