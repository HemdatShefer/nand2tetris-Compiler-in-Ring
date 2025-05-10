Load "CodeWriter.ring"
Load "Parser.ring"
Load "HelperFunctions.ring"

func main()
    see "Enter input directory path: " + nl
    dirPath = input()
    dirPath = trim(dirPath)

    see "You entered: " + dirPath + nl

    allFiles = findVMFiles(dirPath)
    see "Found " + len(allFiles) + " .vm files." + nl

    if len(allFiles) = 0
        see "No .vm files found in the directory." + nl
        return
    ok


    for file in allFiles

        see "Processing file: " + file + nl
        outputFile = getAsmFilePath(file)

        codeWriter = new CodeWriter(outputFile)
        if codeWriter.file_stream = NULL
            see "FATAL ERROR: Cannot write to file: " + outputFile + nl
        ok

        codeWriter.setFileName(file)
        parser = new Parser(file)


        while parser.hasMoreCommands()
            parser.advance()
            cmdType = parser.commandType()

            if cmdType = "C_PUSH" or cmdType = "C_POP"
                segment = parser.arg1()
                index = parser.arg2()
                codeWriter.writePushPop(cmdType, segment, index)
            but cmdType = "C_ARITHMETIC"
                command = parser.arg1()
                codeWriter.writeArithmetic(command)
            but cmdType = "C_LABEL"
                label = parser.arg1()
                codeWriter.writeLabel(label)
            but cmdType = "C_GOTO"
                label = parser.arg1()
                codeWriter.writeGoto(label)
            but cmdType = "C_IF"
                label = parser.arg1()
                codeWriter.writeIf(label)
            but cmdType = "C_FUNCTION"
                fname = parser.arg1()
                nVars = parser.arg2()
                codeWriter.writeFunction(fname, nVars)
            but cmdType = "C_CALL"
                fname = parser.arg1()
                nArgs = parser.arg2()
                codeWriter.writeCall(fname, nArgs)
            but cmdType = "C_RETURN"
                codeWriter.writeReturn()
            ok
        end
        see "Finished processing file: " + file + nl
    next

    codeWriter.close()
    see "Assembly code has been written to " + outputFile + nl
end
