extends Node


func format_clicker_number(value: float, check: int) -> String:
	var abs_value = abs(value)
	var suffixes = ["", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Udc", "Ddc", "Tdc", "Qadc", "Qidc", "Sxdc", "Spdc", "Ocdc", "Nodc", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Ocvg", "Novg", "Tg", "Utg", "Dtg", "G", "Tcg"]
	
	var index = 0
	while abs_value >= 1000000.0 and index < suffixes.size() - 1:
		abs_value /= 1000.0
		index += 1
	match check:
		1:# for Sand Ate
			return  "Sand Ate: " + "%.2f%s" % [abs_value, suffixes[index]] + " oz"		
		2:# for Sand $s
			return  "Sand Dollars: $" + "%.2f%s" % [abs_value, suffixes[index]]	
		3:# for the Consumption Rate
			return "Consumption Rate: " + "%.2f%s" % [abs_value, suffixes[index]] + "X"	
		4:# for Space Sand #
			return "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][wave]Space Sand: " + "%.2f%s" % [abs_value, suffixes[index]]
		5:# for buttons
			return  "%.2f%s" % [abs_value, suffixes[index]]	
		_:
			return "%.2f%s" % [abs_value, suffixes[index]]	
