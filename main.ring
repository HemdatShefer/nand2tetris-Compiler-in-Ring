Load "CodeWriter.ring"
Load "Parser.ring"   // Load the files with the classes

func main()
    see "Enter input directory path: " + nl
    dirPath = input()                   // Get folder path from user
    dirPath = trim(dirPath)            // Remove spaces

    see "You entered: " + dirPath + nl
    allFiles = findVMFiles(dirPath)    // Find all .vm files in the folder
    see "Found " + len(allFiles) + " .vm files." + nl

    if len(allFiles) = 0               // If no .vm files → stop
        see "No .vm files found in the directory." + nl
        return
    ok

    for file in allFiles
        see "Processing file: " + file + nl
        outputFile = getAsmFilePath(file)   // Make .asm file name
        see "Output file path: " + outputFile + nl

        parser = new Parser(file)          // Create parser object
        see "Parser initialized successfully." + nl

        codeWriter = new CodeWriter(outputFile)   // Create writer object
        see "Code writer initialized successfully." + nl

        see "Starting to write hack code for file " + file + nl
        while parser.hasMoreCommands()     // While there are commands
            parser.advance()               // Go to next command
            see "Advanced to next command." + nl

            cmdType = parser.commandType()
            see "Command type: " + cmdType + nl

            if cmdType = "C_PUSH"
                see "Push command." + nl
                segment = parser.arg1()     // Get segment (like local)
                index = parser.arg2()       // Get number
                see "Segment: " + segment + ", Index: " + index + nl
                codeWriter.writePushPop(cmdType, segment, index)
                see "Wrote push command." + nl

            but cmdType = "C_POP"
                see "Pop command." + nl
                segment = parser.arg1()
                index = parser.arg2()
                see "Segment: " + segment + ", Index: " + index + nl
                codeWriter.writePushPop(cmdType, segment, index)
                see "Wrote pop command." + nl
            
            but cmdType = "C_ARITHMETIC"
                see "Arithmetic command." + nl
                command = parser.arg1()
                see "Command: " + command + nl
                codeWriter.writeArithmetic(command)
                see "Wrote arithmetic command." + nl
            ok

        end
        see "Finished processing file: " + file + nl
    next

    see "Closing code writer." + nl
    codeWriter.close()     // Close the output file
    see "Code writer closed." + nl

    see "Assembly code has been written to " + outputFile + nl
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
