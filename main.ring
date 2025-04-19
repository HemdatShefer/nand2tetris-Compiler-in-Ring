Load "CodeWriter.ring"
Load "Parser.ring"

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
        see "Output file path: " + outputFile + nl

        parser = new Parser(file)
        see "Parser initialized successfully." + nl

        codeWriter = new CodeWriter(outputFile)
        see "Code writer initialized successfully." + nl

        see "Starting to write hack code for file " + file + nl
        while parser.hasMoreCommands()
            parser.advance()
            see "Advanced to next command." + nl
            cmdType = parser.commandType()
            see "Command type: " + cmdType + nl
            if cmdType = "C_PUSH"
                see "Push command." + nl
                segment = parser.arg1()
                index = parser.arg2()
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
            ok
        end
        see "Finished processing file: " + file + nl
    next

    see "Closing code writer." + nl
    codeWriter.close()
    see "Code writer closed." + nl

    see "Assembly code has been written to " + outputFile + nl
end



// Recursively find all .vm files in a directory and its subdirectories
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
	    Add(vmFiles, findVMFiles(fullpath), true)

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


// Converts "C:\...\file.vm" to "C:\...\file.asm"
func getAsmFilePath(vmFilePath)
    parts = my_split(vmFilePath, "\\")
    filename = parts[len(parts)]
    folderLength = len(vmFilePath) - len(filename)
    folderPath = left(vmFilePath, folderLength)
    baseName = left(filename, len(filename) - 3)  // remove ".vm"
    return folderPath + baseName + ".asm"
end


