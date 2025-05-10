class CodeWriter 
    NEW_LINE = nl
    labelCount = 0
    file_stream = NULL
    fileName = "" # Added to track current file name
    functionReturnIndex = 0 # Added to track function return labels
    
    func init(fileName)
        self.file_stream = fopen(fileName, "w+")
	see "open file: " + fileName
	
	if not self.file_stream 
	        see "ERROR: Could not open file for writing: " + fileName + nl
	        self.file_stream = NULL
	        return
    	ok

        # Extract just the base filename from the path
        self.fileName = extractFileName(fileName)
    
    func extractFileName(path)
        # Simple function to extract the base filename without extension
        lastSlash = 0
        dotPos = 0
        
        for i = len(path) to 1 step -1
            if substr(path, i, 1) = "/"
                lastSlash = i
                exit
            ok
        next
        
        nameWithExt = substr(path, lastSlash + 1)
        
        for i = 1 to len(nameWithExt)
            if substr(nameWithExt, i, 1) = "."
                dotPos = i
                exit
            ok
        next
        
        if dotPos > 0
            return substr(nameWithExt, 1, dotPos - 1)
        else
            return nameWithExt
        ok
    
    func setFileName(fileName)
        # Update the current file name when translating a new VM file
        self.fileName = extractFileName(fileName)
    
    func writeLine(code)
        fwrite(self.file_stream, code)
    
    func getEqCommandLine(end_label, loop_label)
        result = "//eq" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M-D" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "@" + loop_label + self.NEW_LINE
        result += "D;JNE" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=-1" + self.NEW_LINE
        result += "@" + end_label + self.NEW_LINE
        result += "0;JMP" + self.NEW_LINE
        result += "(" + loop_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=0" + self.NEW_LINE
        result += "(" + end_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M+1" + self.NEW_LINE
        return result

    func getLtCommandLine(end_label, loop_label)
        result = "//lt" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M-D" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "@" + loop_label + self.NEW_LINE
        result += "D;JGE" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=-1" + self.NEW_LINE
        result += "@" + end_label + self.NEW_LINE
        result += "0;JMP" + self.NEW_LINE
        result += "(" + loop_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=0" + self.NEW_LINE
        result += "(" + end_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M+1" + self.NEW_LINE
        return result

    func getGtCommandLine(end_label, loop_label)
        result = "//gt" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M-D" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "@" + loop_label + self.NEW_LINE
        result += "D;JLE" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=-1" + self.NEW_LINE
        result += "@" + end_label + self.NEW_LINE
        result += "0;JMP" + self.NEW_LINE
        result += "(" + loop_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "M=0" + self.NEW_LINE
        result += "(" + end_label + ")" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M+1" + self.NEW_LINE
        return result    
        
    func getAddCode()
        result = "//add" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "A=M-1" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=D+M" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        return result
    
    func getSubCode()
        result = "//sub" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "A=M-1" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M-D" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        return result
    
    func getNegCode()
        result = "//neg" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "A=M-1" + self.NEW_LINE
        result += "M=-M" + self.NEW_LINE
        return result
    
    func getAndCode()
        result = "//and" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M&D" + self.NEW_LINE
        return result
    
    func getOrCode()
        result = "//or" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "M=M-1" + self.NEW_LINE
        result += "A=M" + self.NEW_LINE
        result += "D=M" + self.NEW_LINE
        result += "A=A-1" + self.NEW_LINE
        result += "M=M|D" + self.NEW_LINE
        return result
    
    func getNotCode()
        result = "//not" + self.NEW_LINE
        result += "@SP" + self.NEW_LINE
        result += "A=M-1" + self.NEW_LINE
        result += "M=!M" + self.NEW_LINE
        return result
    
    func writeArithmetic(command)
        newcommand = cleanString(command)
    
        self.labelCount = self.labelCount + 1
        loop_label = "LOOP" + self.labelCount
        end_label = "END" + self.labelCount
        code = ""
        
        if newcommand = "eq"
            code = self.getEqCommandLine(end_label, loop_label)
        but newcommand = "lt"
            code = self.getLtCommandLine(end_label, loop_label)
        but newcommand = "gt"
            code = self.getGtCommandLine(end_label, loop_label)
        but newcommand = "add"
            code = self.getAddCode()
        but newcommand = "sub"
            code = self.getSubCode()
        but newcommand = "neg"
            code = self.getNegCode()
        but newcommand = "and"
            code = self.getAndCode()
        but newcommand = "or"
            code = self.getOrCode()
        but newcommand = "not"
            code = self.getNotCode()
        else
            code = "ERROR: Invalid arithmetic command " + command
            see "ERROR: Invalid arithmetic command " + command
        ok
        
        self.writeLine(code)
    
    func writePushPop(command, segment, index)
        code = ""
        if command = "C_PUSH"
            code = self.getPushCommandLine(segment, index)
        but command = "C_POP"
            code = self.getPopCommandLine(segment, index)
        ok
        self.writeLine(code)
    
    func getPopCommandLine(segment, index)
        code = ""
        
        if segment = "local"
            code = "//pop local " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@LCL" + self.NEW_LINE
            code += "D=D+M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "argument"
            code = "//pop argument " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@ARG" + self.NEW_LINE
            code += "D=D+M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "this"
            code = "//pop this " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THIS" + self.NEW_LINE
            code += "D=D+M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "that"
            code = "//pop that " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THAT" + self.NEW_LINE
            code += "D=D+M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "pointer"
            code = "//pop pointer " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THIS" + self.NEW_LINE
            code += "D=D+A" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "temp"
            code = "//pop temp " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@5" + self.NEW_LINE
            code += "D=D+A" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@13" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        but segment = "static"
            code = "//pop static " + index + self.NEW_LINE
            # Modified to use fileName.index format for static variables
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@" + self.fileName + "." + index + self.NEW_LINE
            code += "M=D" + self.NEW_LINE

        else
            code = "ERROR: Invalid segment " + segment
        ok
        
        return code
    
    func getPushCommandLine(segment, index)
        code = ""
        
        if segment = "local"
            code = "//push local " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@LCL" + self.NEW_LINE
            code += "A=M+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "constant"
            code = "//push constant " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "argument"
            code = "//push argument " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@ARG" + self.NEW_LINE
            code += "A=M+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "this"
            code = "//push this " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THIS" + self.NEW_LINE
            code += "A=M+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "that"
            code = "//push that " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THAT" + self.NEW_LINE
            code += "A=M+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE
            
        but segment = "pointer"
            code = "//push pointer " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@THIS" + self.NEW_LINE
            code += "A=A+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "temp"
            code = "//push temp " + index + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "D=A" + self.NEW_LINE
            code += "@5" + self.NEW_LINE
            code += "A=A+D" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE

        but segment = "static"
            code = "//push static " + index + self.NEW_LINE
            # Modified to use fileName.index format for static variables
            code += "@" + self.fileName + "." + index + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE
        else
            code = "ERROR: Invalid segment " + segment
        ok
        
        return code
    
    # NEW FUNCTION: Write label command
    func writeLabel(label)
        # Write assembly code that effects the label command
        code = "//label " + label + self.NEW_LINE
        code += "(" + label + ")" + self.NEW_LINE
        self.writeLine(code)
    
    # NEW FUNCTION: Write goto command
    func writeGoto(label) 
        # Write assembly code that effects the goto command
        code = "//goto " + label + self.NEW_LINE
        code += "@" + label + self.NEW_LINE
        code += "0;JMP" + self.NEW_LINE
        self.writeLine(code)
    
    # NEW FUNCTION: Write if-goto command
    func writeIf(label)
        # Write assembly code that effects the if-goto command
        code = "//if-goto " + label + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@" + label + self.NEW_LINE
        code += "D;JNE" + self.NEW_LINE
        self.writeLine(code)
    
    # NEW FUNCTION: Write VM initialization (bootstrap code)
    func writeInit()
        # Write assembly code that effects the VM initialization
        code = "//Bootstrap code" + self.NEW_LINE
        code += "@256" + self.NEW_LINE
        code += "D=A" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        self.writeLine(code)
        
        # Call Sys.init with 0 arguments
        self.writeCall("Sys.init", 0)
    
    # NEW FUNCTION: Write function command
    func writeFunction(functionName, numLocals)
        # Write assembly code that effects the function command
        code = "//function " + functionName + " " + numLocals + self.NEW_LINE
        code += "(" + functionName + ")" + self.NEW_LINE
        
        # Initialize local variables to 0
        for i = 1 to numLocals
            code += "@SP" + self.NEW_LINE
            code += "A=M" + self.NEW_LINE
            code += "M=0" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M+1" + self.NEW_LINE
        next
        
        self.writeLine(code)
    
    # NEW FUNCTION: Write call command
    func writeCall(functionName, numArgs)
        # Generate return address
        self.functionReturnIndex++
        returnLabel = "RETURN_ADDRESS." + functionName + "." + self.functionReturnIndex
        
        code = "//call " + functionName + " " + numArgs + self.NEW_LINE
        
        # Push return address
        code += "@" + returnLabel + self.NEW_LINE
        code += "D=A" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=M+1" + self.NEW_LINE
        
        # Push LCL
        code += "@LCL" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=M+1" + self.NEW_LINE
        
        # Push ARG
        code += "@ARG" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=M+1" + self.NEW_LINE
        
        # Push THIS
        code += "@THIS" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=M+1" + self.NEW_LINE
        
        # Push THAT
        code += "@THAT" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=M+1" + self.NEW_LINE
        
        # ARG = SP - 5 - numArgs
        code += "@SP" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@5" + self.NEW_LINE
        code += "D=D-A" + self.NEW_LINE
        code += "@" + numArgs + self.NEW_LINE
        code += "D=D-A" + self.NEW_LINE
        code += "@ARG" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # LCL = SP
        code += "@SP" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@LCL" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # Jump to function
        code += "@" + functionName + self.NEW_LINE
        code += "0;JMP" + self.NEW_LINE
        
        # Define return address label
        code += "(" + returnLabel + ")" + self.NEW_LINE
        
        self.writeLine(code)
    
    # NEW FUNCTION: Write return command
    func writeReturn()
        code = "//return" + self.NEW_LINE
        
        # FRAME = LCL (R13 is FRAME)
        code += "@LCL" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@R13" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # RET = *(FRAME-5) (R14 is RET)
        code += "@5" + self.NEW_LINE
        code += "A=D-A" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@R14" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # *ARG = pop()
        code += "@SP" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@ARG" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # SP = ARG + 1
        code += "@ARG" + self.NEW_LINE
        code += "D=M+1" + self.NEW_LINE
        code += "@SP" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # THAT = *(FRAME-1)
        code += "@R13" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@THAT" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # THIS = *(FRAME-2)
        code += "@R13" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@THIS" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # ARG = *(FRAME-3)
        code += "@R13" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@ARG" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # LCL = *(FRAME-4)
        code += "@R13" + self.NEW_LINE
        code += "AM=M-1" + self.NEW_LINE
        code += "D=M" + self.NEW_LINE
        code += "@LCL" + self.NEW_LINE
        code += "M=D" + self.NEW_LINE
        
        # goto RET
        code += "@R14" + self.NEW_LINE
        code += "A=M" + self.NEW_LINE
        code += "0;JMP" + self.NEW_LINE
        
        self.writeLine(code)
    
    func close()
	if not self.file_stream 
	        see "ERROR: Could not open file for writing: " + fileName + nl
	ok
        fclose(self.file_stream)
        self.file_stream = NULL
    
#end

func cleanString(str)
    cleaned = ""
    for i = 1 to len(str)
        ch = substr(str, i, 1)
        asciiVal = ascii(ch)
        if asciiVal >= 33 and asciiVal <= 126  # Visible characters only
            cleaned += ch
        ok
    next
    return cleaned
