extends Node2D
@export var Sand: float = 1
#@export var Sand_Mult: float = 1
@export var Sand_Total: float = 0
@export var Sand_Dollars: float = 0
var next_input: bool = false
@export var s_label: String
@export var s_label_d: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SandValueLabel.text = "Sand Eatten: "
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left") && next_input == false:
		Sand_Total += Sand
		Sand_Dollars += Sand
		
		Level_Vars.Sand_Eatten_Label.text = "Sand Eatten: " + str(Sand_Total) + " .lbs"
		s_label = Level_Vars.Sand_Eatten_Label.text
		
		Level_Vars.Sand_Dollar_Label.text = "Sand Dollars: $" + str(Sand_Dollars)
		s_label_d = Level_Vars.Sand_Dollar_Label.text
		
		next_input = true
	
	if Input.is_action_just_pressed("right") && next_input == true:
		Sand_Total += Sand
		Sand_Dollars += Sand
		
		Level_Vars.Sand_Eatten_Label.text = "Sand Eatten: " + str(Sand_Total) + " .lbs"
		s_label = Level_Vars.Sand_Eatten_Label.text
		
		Level_Vars.Sand_Dollar_Label.text = "Sand Dollars: $" + str(Sand_Dollars)
		s_label_d = Level_Vars.Sand_Dollar_Label.text
		
		next_input = false
