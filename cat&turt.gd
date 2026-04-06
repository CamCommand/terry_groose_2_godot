extends Node2D

@export var dragging = false
@export var offset = Vector2(0,0)

@export var distance: float
@export var distancex: float
@export var distancey: float

var float_time := 0.0
var float_amplitude := 8.0
var float_speed := 2.0

@onready var turtle: Sprite2D = $"Turtle-o"
@onready var sphinx: Sprite2D = $"Sphinx-o"

#moving target variables
@export var stop_distance = 100 #stopping right "before" they are exactly same position
@export var speed = 25.0 # pixels/sec

@onready var sphinx_sfx: AudioStreamPlayer2D = $Cat2Audio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	float_time += delta
	var float_rng := RandomNumberGenerator.new()
	float_rng.randomize()
	#floating stuff
	for node in get_children():
		if node is Sprite2D and node.name.ends_with("x-o"):
			# float amplitude
			if not node.has_meta("float_amplitude"):
				node.set_meta("float_amplitude", 10) # pixels
				
			# Store original Y once
			if not node.has_meta("base_y"):
				node.set_meta("base_y", node.position.y)
			
			var base_y = node.get_meta("base_y")
			node.position.y = base_y + sin(float_time * float_speed) * float_amplitude
	#move turtle on drag
	if dragging:
		turtle.global_position = get_global_mouse_position() - offset
	#getting the distance of pixels between two sprites
	var to_sphinx = sphinx.global_position - turtle.global_position
	var dist = to_sphinx.length()
	#flip when on other side of cat
	turtle.flip_h = (turtle.global_position.x < sphinx.global_position.x)	
	
	var main = get_tree().get_first_node_in_group("main")
	if dist > stop_distance:
		var dir = to_sphinx.normalized()
		turtle.global_position += dir * speed * delta #moves turtle towards sphinx
		#adding the distance x the muliplyer to the sand counts
		main.Sand_Total_Eaten += main.SpaceTurtleMultiplyer * dist * 1000000
		main.Space_Sand += main.SpaceTurtleMultiplyer * dist * 1000000
		sphinx_sfx.autoplay = false
	else:
		#subtracting the distance x the muliplyer to the sand counts
		main.Space_Sand -= main.SpaceTurtleMultiplyer * dist
		sphinx_sfx.autoplay = true
		#play sfx when turtle touches sphinx
		if not sphinx_sfx.is_playing():
			sphinx_sfx.play()

func _on_turtle_button_button_down() -> void:
	dragging = true
	#offset = get_global_mouse_position() - global_position

func _on_turtle_button_button_up() -> void:
	dragging = false
