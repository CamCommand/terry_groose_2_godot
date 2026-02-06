extends Node2D

@export var SpoonUpgradeCost: float = 100
@export var SpoonCounter: float
@export var SpoonCheck: bool
@export var SuperSpoonCheck: bool

@onready var Sand_Eatten_Label: Label = $Sand_Eatten_Label
@onready var Sand_Dollar_Label: Label = $Sand_Dollar_Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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
	if SpoonCheck == true && Player_Vars.Sand_Dollars >= SpoonUpgradeCost && SpoonCounter < 11:
		Player_Vars.Sand_Dollars -= SpoonUpgradeCost
	else:
		$SpoonButton.text = "Buy Spoon:" + "\n"  + "100"
		Player_Vars.Sand_Dollars -= SpoonUpgradeCost
		SpoonCheck = true
		Player_Vars.Sand = Player_Vars.Sand * 1.1


func _on_spoon_timer_timeout() -> void:
	if SpoonCheck == true:
		$SpoonButton.text = "Spoon Upgrade:" + "\n"  + str(SpoonUpgradeCost)
	else:
		$SpoonButton.text = "Buy Spoon:" + "\n"  + "100"
