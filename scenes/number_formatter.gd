extends Node


func format_clicker_number(value: float, check: int) -> String:
	var abs_value = abs(value)
	var suffixes = ["", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Udc", "Ddc", "Tdc", "Qadc", "Qidc", "Sxdc", "Spdc", "Ocdc", "Nodc", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Ocvg", "Novg", "Tg", "Utg", "Dtg", "G"]
	
	var index = 0
	while abs_value >= 1000000.0 and index < suffixes.size() - 1:
		abs_value /= 1000.0
		index += 1
	match check:
		1:
			return  "Sand Ate: " + "%.2f%s" % [abs_value, suffixes[index]] + " oz"		
		2:
			return  "Sand Dollars: $" + "%.2f%s" % [abs_value, suffixes[index]]	
		3:
			return "Consumption Rate: " + "%.2f%s" % [abs_value, suffixes[index]] + "X"	
		_:
			return "%.2f%s" % [abs_value, suffixes[index]]	
