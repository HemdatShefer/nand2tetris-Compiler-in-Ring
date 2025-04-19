Load "stdlib.ring"
Load "HelperFunctions.ring"

class Parser 

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
    while hasMoreCommands()

        currentLine = fgets(file_handle, 200)

        if currentLine = NULL
            splittedLine = []
            finished = true
            return
        ok

        currentLine = string(currentLine)
        currentLine = trim(currentLine)

        # Remove inline comments
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
            loop  # skip to next line
        else
            splittedLine = my_split(currentLine, " ")
            return  # successfully advanced to a real command
        ok

    end
    # If we're here, no more valid commands
	splittedLine = []
	finished = true
	
	see "Current line: " + parser.currentLine + nl
	see "Splitted: " + parser.splittedLine + nl




func commandType()
    # Check if splittedLine exists and is a list
    if not isList(splittedLine) or len(splittedLine) < 1
        return "C_NONE"
    ok

    # Make sure we have an element and it's a string before using lower/trim
    if isString(splittedLine[1])
        cmd = lower(trim(splittedLine[1]))
    else
        return "C_NONE"
    ok

    see "DEBUG: command = " + cmd + nl

    switch cmd
    on "push"
        return "C_PUSH"
    on "pop"
        return "C_POP"

    # Arithmetic/logical commands
    on "add"+char(10)
        return  "C_ARITHMETIC"
    on "sub"+char(10)
        return "C_ARITHMETIC"
    on "neg"+char(10)
        return "C_ARITHMETIC"
    on "eq"+char(10)
        return "C_ARITHMETIC"
    on "gt"+char(10)
        return "C_ARITHMETIC"
    on "lt"+char(10)
        return "C_ARITHMETIC"
    on "and"+char(10)
        return "C_ARITHMETIC"
    on "or"+char(10)
        return "C_ARITHMETIC"
    on "not"+char(10)
        return "C_ARITHMETIC"

    other
        return "C_NONE"
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
        if (ctype = "C_PUSH") or (ctype = "C_POP") 
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
