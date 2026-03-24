extends Node2D

@export var night_counter: int
@export var night_bool: bool = true

# day and night "cycle" code ->to tweak speed, change Wait Time of NightTimer
func _on_night_timer_timeout() -> void:
	if $DarknessFilter.self_modulate.a < 1 && night_bool == true:
		#print("Getting darker " + str($DarknessFilter.self_modulate.a) + " and count = " + str(night_counter))
		night_counter += 1
		$DarknessFilter.self_modulate.a += 0.015
		if night_counter == 50:
			night_bool = false
	elif $DarknessFilter.self_modulate.a > 0.015 && night_bool == false:
		night_counter -= 1
		$DarknessFilter.self_modulate.a -= 0.015
		#print("Getting brighter " + str($DarknessFilter.self_modulate.a) + " and count = " + str(night_counter))
		if night_counter == 1:
			night_bool = true
