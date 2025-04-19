class CodeWriter 
    NEW_LINE = nl
    labelCount = 0
    file_stream = NULL
    
    func init(fileName)
        self.file_stream = fopen(fileName, "w+") 
    
    func writeLine(code)
        fwrite(self.file_stream, code)
    
    func getEqCommandLine(end_label, loop_label)
        result = ""
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
        result = ""
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
        result = ""
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
        result = "//add" + nl
        result += "@SP" + nl
        result += "M=M-1" + nl
        result += "A=M" + nl
        result += "D=M" + nl
        result += "A=A-1" + nl
        result += "M=M+D" + nl
        return result
    
    func getSubCode()
        result = "//sub" + nl
        result += "@SP" + nl
        result += "M=M-1" + nl
        result += "A=M" + nl
        result += "D=M" + nl
        result += "A=A-1" + nl
        result += "M=M-D" + nl
        return result
    
    func getNegCode()
        result = "//neg" + nl
        result += "@SP" + nl
        result += "A=M-1" + nl
        result += "M=-M" + nl
        return result
    
    func getAndCode()
        result = "//and" + nl
        result += "@SP" + nl
        result += "M=M-1" + nl
        result += "A=M" + nl
        result += "D=M" + nl
        result += "A=A-1" + nl
        result += "M=M&D" + nl
        return result
    
    func getOrCode()
        result = "//or" + nl
        result += "@SP" + nl
        result += "M=M-1" + nl
        result += "A=M" + nl
        result += "D=M" + nl
        result += "A=A-1" + nl
        result += "M=M|D" + nl
        return result
    
    func getNotCode()
        result = "//not" + nl
        result += "@SP" + nl
        result += "A=M-1" + nl
        result += "M=!M" + nl
        return result
    
    func writeArithmetic(command)
        self.labelCount = self.labelCount + 1
        loop_label = "LOOP" + self.labelCount
        end_label = "END" + self.labelCount
        code = ""
        
        if command = "eq"
            code = self.getEqCommandLine(end_label, loop_label)
        but command = "lt"
            code = self.getLtCommandLine(end_label, loop_label)
        but command = "gt"
            code = self.getGtCommandLine(end_label, loop_label)
        but command = "add"
            code = self.getAddCode()
        but command = "sub"
            code = self.getSubCode()
        but command = "neg"
            code = self.getNegCode()
        but command = "and"
            code = self.getAndCode()
        but command = "or"
            code = self.getOrCode()
        but command = "not"
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
            code += "@SP" + self.NEW_LINE
            code += "A=M-1" + self.NEW_LINE
            code += "D=M" + self.NEW_LINE
            code += "@" + index + self.NEW_LINE
            code += "M=D" + self.NEW_LINE
            code += "@SP" + self.NEW_LINE
            code += "M=M-1" + self.NEW_LINE

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
            code += "@" + index + self.NEW_LINE
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
    
    func close()
        fclose(self.file_stream)
        self.file_stream = NULL
    
end


