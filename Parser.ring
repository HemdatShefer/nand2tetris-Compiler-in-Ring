Load "stdlib.ring"
Load "HelperFunctions.ring"

class Parser 

    // define class variables for file, current line, split line, and finish flag
    file_handle currentLine splittedLine finished

    func init (filePath)
        file_handle = fopen(filePath, "r")
        if file_handle = 0
            see "Error opening file: " + filePath + nl
            finished = true
        else
            finished = false
        ok

        currentLine = ""
        splittedLine = []

    func hasMoreCommands()
        if finished
            return false
        else
            return (feof(file_handle) = 0)
        ok



    func advance()
        while self.hasMoreCommands()
            currentLine = fgets(file_handle, 200)

            if currentLine = NULL
                splittedLine = []
                finished = true
                return
            ok

            currentLine = trim(string(currentLine))

            try
                pos = find(currentLine, "//")
            catch
                pos = 0
            end

            if pos > 0
                currentLine = left(currentLine, pos - 1)
            ok

            currentLine = trim(currentLine)

            if currentLine = ""
                loop
            else
                splittedLine = my_split(currentLine, " ")
                return
            ok
        end

        splittedLine = []
        finished = true

        see "Current line: " + currentLine + nl
        see "Splitted: " + splittedLine + nl




    func commandType()
        if not isList(splittedLine) or len(splittedLine) < 1
            return "C_NONE"
        ok

        cmd = lower(trim(splittedLine[1]))

        switch cmd
        on "push"       return "C_PUSH"
        on "pop"        return "C_POP"
        on "label"      return "C_LABEL"
        on "goto"       return "C_GOTO"
        on "if-goto"    return "C_IF"
        on "function"   return "C_FUNCTION"
        on "call"       return "C_CALL"
        on "return"     return "C_RETURN"
        on "add"
        on "sub"
        on "neg"
        on "eq"
        on "gt"
        on "lt"
        on "and"
        on "or"
        on "not"        return "C_ARITHMETIC"
        other           return "C_NONE"
        off

    func arg1()
        ctype = commandType()
        if ctype = "C_NONE"
            return ""
        ok

        if ctype = "C_ARITHMETIC"
            return lower(trim(splittedLine[1]))

        else
            if len(splittedLine) >= 2
                return trim(splittedLine[2])
            else
                return ""
            ok
        ok

    func arg2()
        ctype = commandType()
        if (ctype = "C_PUSH") or (ctype = "C_POP") or (ctype = "C_FUNCTION") or (ctype = "C_CALL")
            if len(splittedLine) >= 3
                return trim(splittedLine[3])
            else
                return "0"
            ok
        else
            return "0"
        ok


    func close()
        if file_handle != 0
            fclose(file_handle)
        ok
end
