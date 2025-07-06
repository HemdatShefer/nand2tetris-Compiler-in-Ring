class VMWriter 
	
	result = []

	func init (filePath)
		result = []

	end

	// segment (CONSTANT, ARG, LOCAL, STATIC, THIS, THAT, POINTER, TEMP)
	// index is the index in the segment
	func writePush (segment, index)
		segment = lower(segment)
		add(result, "push " + segment + " " + string(index) + "\n")
	end 


	// segment (CONSTANT, ARG, LOCAL, STATIC, THIS, THAT, POINTER, TEMP)
	// index is the index in the segment
	func writePop (segment, index)
		segment = lower(segment)
		add(result, "pop " + segment + " " + string(index) + "\n")
	end

	// command is one of the arithmetic commands (ADD, SUB, NEG, EQ, GT, LT, AND, OR, NOT)
	func writeArithmetic (command)
		command = lower(command)
		if command = "add" or command = "sub" or command = "neg" or command = "eq" or command = "gt" or command = "lt" or command = "and" or command = "or" or command = "not"
			add(result, command + "\n")
		else
			see "ERROR: Invalid arithmetic command: " + command + nl
		ok

	end
