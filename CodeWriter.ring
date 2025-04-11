class CodeWriter {
    NEW_LINE = nl
    labelCount = 0
    arithmetic = {
        "add": "//add" + nl +
               "@SP" + nl +
               "M=M-1" + nl +
               "A=M" + nl +
               "D=M" + nl +
               "A=A-1" + nl +
               "M=M+D" + nl,
        "sub": "//sub" + nl +
               "@SP" + nl +
               "M=M-1" + nl +
               "A=M" + nl +
               "D=M" + nl +
               "A=A-1" + nl +
               "M=M-D" + nl,
        "neg": "//neg" + nl +
               "@SP" + nl +
               "A=M-1" + nl +
               "M=-M" + nl,
        "and": "//and" + nl +
               "@SP" + nl +
               "M=M-1" + nl +
               "A=M" + nl +
               "D=M" + nl +
               "A=A-1" + nl +
               "M=M&D" + nl,
        "or":  "//or" + nl +
               "@SP" + nl +
               "M=M-1" + nl +
               "A=M" + nl +
               "D=M" + nl +
               "A=A-1" + nl +
               "M=M|D" + nl,
        "not": "//not" + nl +
               "@SP" + nl +
               "A=M-1" + nl +
               "M=!M" + nl
    }

    file_stream = 0

///.......................................
/// Opens a file with the given name and connects it to the file stream.
///.......................................
    method init(fileName) { //////////////////////////////////////// This function is basically a constructor
        self.file_stream = fopen(fileName, "w+") 
    }

///.......................................
/// Writes a line of code to the file from the file stream.
///.......................................
    method writeLine(code) {
        Fwrite(self.file_stream, code)
    }

///.......................................
/// Creates code for an equality comparison. 
/// It subtracts two values from the stack and puts -1 if they are equal, or 0 if they are not.
///.......................................
    method getEqCommandLine(end_label, loop_label) {
        local result = ""
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "A=A-1" + self.NEW_LINE
        result = result + "M=M-D" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "@" + loop_label + self.NEW_LINE
        result = result + "D;JNE" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=-1" + self.NEW_LINE
        result = result + "@" + end_label + self.NEW_LINE
        result = result + "0;JMP" + self.NEW_LINE
        result = result + "(" + loop_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=0" + self.NEW_LINE
        result = result + "(" + end_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M+1" + self.NEW_LINE
        return result
    }

///.......................................
/// Creates code for a less-than comparison. 
/// It compares two values and puts -1 if the first value is smaller, or 0 if it is not.
///.......................................
    method getLtCommandLine(end_label, loop_label) {
        local result = ""
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "A=A-1" + self.NEW_LINE
        result = result + "M=M-D" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "@" + loop_label + self.NEW_LINE
        result = result + "D;JGE" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=-1" + self.NEW_LINE
        result = result + "@" + end_label + self.NEW_LINE
        result = result + "0;JMP" + self.NEW_LINE
        result = result + "(" + loop_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=0" + self.NEW_LINE
        result = result + "(" + end_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M+1" + self.NEW_LINE
        return result
    }

///.......................................
/// Creates code for a greater-than comparison. 
/// It compares two values and puts -1 if the first value is greater, or 0 if it is not.
///.......................................
    method getGtCommandLine(end_label, loop_label) {
        local result = ""
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "A=A-1" + self.NEW_LINE
        result = result + "M=M-D" + self.NEW_LINE
        result = result + "D=M" + self.NEW_LINE
        result = result + "@" + loop_label + self.NEW_LINE
        result = result + "D;JLE" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=-1" + self.NEW_LINE
        result = result + "@" + end_label + self.NEW_LINE
        result = result + "0;JMP" + self.NEW_LINE
        result = result + "(" + loop_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M-1" + self.NEW_LINE
        result = result + "A=M" + self.NEW_LINE
        result = result + "M=0" + self.NEW_LINE
        result = result + "(" + end_label + ")" + self.NEW_LINE
        result = result + "@SP" + self.NEW_LINE
        result = result + "M=M+1" + self.NEW_LINE
        return result
    }

///.......................................
/// Generates code for arithmetic commands like add, sub, neg, and, or, not, eq, lt, or gt.
///.......................................
    method writeArithmetic(command) {
        self.labelCount = self.labelCount + 1
        local loop_label = "LOOP" + self.labelCount
        local end_label = "END" + self.labelCount
        local code = ""
        if command == "eq" {
            code = self.getEqCommandLine(end_label, loop_label)
        } elseif command == "lt" {
            code = self.getLtCommandLine(end_label, loop_label)
        } elseif command == "gt" {
            code = self.getGtCommandLine(end_label, loop_label)
        } else {
            code = self.arithmetic[command]
        }
        self.writeLine(code)
    }

///.......................................
/// Writes code for push or pop commands based on the segment (like local, argument, etc.) 
/// and the index provided.
///.......................................
    method writePushPop(command, segment, index) {
        local code = ""
        if command == "push" {
            code = self.getPushCommandLine(segment, index)
        } elseif command == "pop" {
            code = self.getPopCommandLine(segment, index)
        }
        self.writeLine(code)
    }

///.......................................
/// Creates code for a pop command for different segments like local, argument, this, that, pointer, temp, static.
///.......................................
    method getPopCommandLine(segment, index) {
        local code = ""
        if segment == "local" {
            code = "//pop local " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@LCL" + self.NEW_LINE +
                   "D=D+M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "argument" {
            code = "//pop argument " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@ARG" + self.NEW_LINE +
                   "D=D+M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "this" {
            code = "//pop this " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THIS" + self.NEW_LINE +
                   "D=D+M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "that" {
            code = "//pop that " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THAT" + self.NEW_LINE +
                   "D=D+M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "pointer" {
            code = "//pop pointer " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THIS" + self.NEW_LINE +
                   "D=D+A" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "temp" {
            code = "//pop temp " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@5" + self.NEW_LINE +
                   "D=D+A" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@13" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE
        } elseif segment == "static" {
            code = "//pop static " + index + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M-1" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M-1" + self.NEW_LINE
        } else {
            code = "ERROR: Invalid segment " + segment
        }
        return code
    }

///.......................................
/// Creates code for a push command for different segments like local, constant, argument, this, that, pointer, temp, static.
///.......................................
    method getPushCommandLine(segment, index) {
        local code = ""
        if segment == "local" {
            code = "//push local " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@LCL" + self.NEW_LINE +
                   "A=M+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "constant" {
            code = "//push constant " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "argument" {
            code = "//push argument " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@ARG" + self.NEW_LINE +
                   "A=M+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "this" {
            code = "//push this " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THIS" + self.NEW_LINE +
                   "A=M+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "that" {
            code = "//push that " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THAT" + self.NEW_LINE +
                   "A=M+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "pointer" {
            code = "//push pointer " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@THIS" + self.NEW_LINE +
                   "A=A+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "temp" {
            code = "//push temp " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=A" + self.NEW_LINE +
                   "@5" + self.NEW_LINE +
                   "A=A+D" + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } elseif segment == "static" {
            code = "//push static " + index + self.NEW_LINE +
                   "@" + index + self.NEW_LINE +
                   "D=M" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "A=M" + self.NEW_LINE +
                   "M=D" + self.NEW_LINE +
                   "@SP" + self.NEW_LINE +
                   "M=M+1" + self.NEW_LINE
        } else {
            code = "ERROR: Invalid segment " + segment
        }
        return code
    }
}

/// Close a file that was opened using fopen()

    method close(fileName){
        fclose(fileName)
        self.file_stream = 0
    }
