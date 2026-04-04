extends Node2D

@export var dragging = false
@export var offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging:
		$Turtle.position = get_global_mouse_position() #- offset

func _on_turtle_button_button_down() -> void:
	dragging = true
	#offset = get_global_mouse_position() - global_position


func _on_turtle_button_button_up() -> void:
	dragging = false
