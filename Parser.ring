Load "stdlib.ring"
Load "HelperFunctions.ring"

class Parser 

    file_handle currentLine splittedLine finished

    func init filePath
        file_handle = fopen(filePath, "r")
        if file_handle = 0
            see "Error opening file: " + filePath + nl
            finished = true
        else
            finished = false
        ok

        currentLine = ""
        splittedLine = []

    func hasMoreCommands
        if finished
            return false
        else
            return (feof(file_handle) = 0)
        ok

    func advance
        if not hasMoreCommands()
            finished = true
            return
        ok

        currentLine = fgets(file_handle, 200)
        currentLine = trim(currentLine)

        pos = find(currentLine, "//")
        if pos > 0
            currentLine = left(currentLine, pos - 1)
        ok

        currentLine = trim(currentLine)

        if currentLine = ""
            splittedLine = []
        else
            splittedLine = my_split(currentLine, " ")
        ok

    func commandType
        if splittedLine.len() < 1
            return "C_NONE"
        ok

        cmd = lower(trim(splittedLine[1]))
        switch cmd
        on "push"
            return "C_PUSH"
        on "pop"
            return "C_POP"
        on "label"
            return "C_LABEL"
        on "goto"
            return "C_GOTO"
        on "if-goto"
            return "C_IF"
        on "function"
            return "C_FUNCTION"
        on "call"
            return "C_CALL"
        on "return"
            return "C_RETURN"
        on "add" ; on "sub" ; on "neg"
        on "eq"  ; on "gt"  ; on "lt"
        on "and" ; on "or"  ; on "not"
            return "C_ARITHMETIC"
        other
            return "C_NONE"
        off

    func arg1
        ctype = commandType()
        if ctype = "C_NONE"
            return ""
        ok

        if ctype = "C_ARITHMETIC"
            return trim(splittedLine[1])
        elseif ctype = "C_RETURN"
            return ""
        else
            if splittedLine.len() >= 2
                return trim(splittedLine[2])
            else
                return ""
            ok
        ok

    func arg2
        ctype = commandType()
        if (ctype = "C_PUSH") or (ctype = "C_POP") 
            if splittedLine.len() >= 3
                return trim(splittedLine[3])
            else
                return "0"
            ok
        else
            return "0"
        ok

    func close
        if file_handle != 0
            fclose(file_handle)
        ok
