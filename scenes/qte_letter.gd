extends Control

signal finished(success) 
signal qte_success(Space_Sand)

@export var keyString: String = "Q"
@export var keyCode: Key = KEY_Q
@onready var letter: Label = $Letter
var tween : Tween
var success = false
@export var Space_Sand: float = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	letter.text = keyString
	
	await _animation()
	
	#time after tween is complete
	await get_tree().create_timer(.25).timeout
	
	if not success:
		finished.emit(false)
		print("missed window")
		queue_free()

func _animation():
	tween = create_tween()
	tween.tween_property($Letter, "scale", Vector2(1,1), 3.5).from(Vector2(0.5, 0.5))
	await tween.finished
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not success:
		if event.keycode == keyCode:
			success = true
			#print("success")
			#Space_Sand = Space_Sand * 2
			emit_signal("qte_success", Space_Sand)
			
			if tween:
				tween.kill()

			finished.emit(true)
			queue_free()
		else:
			print("wrong key")
			
			if tween:
				tween.kill()

			finished.emit(false)
			queue_free()
