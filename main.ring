Load "CodeWriter.ring"
Load "Parser.ring"   // Load the files with the classes

func main()
    see "Enter input directory path: " + nl
    dirPath = input()  // Get folder path from user
    dirPath = trim(dirPath)

    allFiles = findVMFiles(dirPath)  // Find all .vm files in the folder
    if len(allFiles) = 0  // If no .vm files → stop
        see "No .vm files found in the directory." + nl
        return
    ok

    outputFile = getAsmFilePath(allFiles[1])  // Use first file to derive output path
    if right(dirPath, 3) != ".vm"  // Directory input: override with directory-based name
        parts = my_split(dirPath, "\\")
        dirName = parts[len(parts)]
        outputFile = dirPath + "\\" + dirName + ".asm"
    ok

    codeWriter = new CodeWriter(outputFile)  // Create writer object
    codeWriter.writeInit()  // Write bootstrap code

    for file in allFiles
        codeWriter.setFileName(file)  // Set current file for symbol generation
        parser = new Parser(file)  // Create parser object

        while parser.hasMoreCommands()  // While there are commands
            parser.advance()  // Go to next command
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
                functionName = parser.arg1()
                nVars = parser.arg2()
                codeWriter.writeFunction(functionName, nVars)
            
            but cmdType = "C_CALL"
                functionName = parser.arg1()
                nArgs = parser.arg2()
                codeWriter.writeCall(functionName, nArgs)
            
            but cmdType = "C_RETURN"
                codeWriter.writeReturn()
            ok
        end
    next

    codeWriter.close()  // Close the output file
    see "File created: " + outputFile + nl
end


// This function finds all .vm files in folder (and subfolders)
func findVMFiles(path)
    see "Scanning path: " + path + nl

    vmFiles = []
    dirContent = dir(path)

    if dirContent = 0
        see "ERROR: Could not open directory: " + path + nl
        return vmFiles
    ok

    for entry in dirContent
        name = entry[1]
        isDir = entry[2]
        fullpath = path + "\\" + name

        if isDir
            see "Entering directory: " + fullpath + nl
	        Add(vmFiles, findVMFiles(fullpath), true)  // Go inside folder

        else
            see "Found file: " + fullpath + nl
            if right(name, 3) = ".vm"
                see "Matched .vm file: " + fullpath + nl
                add(vmFiles, fullpath)
            ok
        ok
    next

    return vmFiles
end


// This function changes .vm to .asm in file name
func getAsmFilePath(vmFilePath)
    parts = my_split(vmFilePath, "\\")                // Split path
    filename = parts[len(parts)]                      // Get file name
    folderLength = len(vmFilePath) - len(filename)    // Get length without file name
    folderPath = left(vmFilePath, folderLength)       // Get folder path
    baseName = left(filename, len(filename) - 3)      // Remove ".vm"
    return folderPath + baseName + ".asm"             // Add ".asm"
end
