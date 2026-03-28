extends Label

func _ready():
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y - 50, 1.0)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 3.5)
	
	tween.finished.connect(queue_free)
