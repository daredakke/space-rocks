extends Node


# From https://pastebin.com/STHPc0mD
func format_integer(number: int) -> String:
	var value := str(number)
	var output := ""
	
	for i in value.length():
		if i != 0 and i % 3 == value.length() % 3:
			output += ","
		
		output += value[i]
	
	return output
