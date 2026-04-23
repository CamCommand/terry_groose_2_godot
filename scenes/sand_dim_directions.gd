extends Label
var fade_duration = 10.5

func _ready():
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y - 50, 1.0)
	tween.parallel().tween_property(self, "modulate:a", 0.0, fade_duration)
	
	tween.finished.connect(queue_free)
