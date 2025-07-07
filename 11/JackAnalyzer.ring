Load "JackTokenizer.ring"
Load "CompilationEngine.ring"
Load "HelperFunctions.ring"

func main()
    see "Enter source (file or directory): " + nl
    source = trim(input())
    
    see "You entered: " + source + nl
    
    # Check if source is a file or directory
    if right(source, 5) = ".jack"
        # Single file
        compileFile(source)
    else
        # Directory - find all .jack files
        jackFiles = findJackFiles(source)
        see "Found " + len(jackFiles) + " .jack files." + nl
        
        if len(jackFiles) = 0
            see "No .jack files found in the directory." + nl
            return
        ok
        
        for file in jackFiles
            compileFile(file)
        next
    ok
    
    see "Jack compilation completed." + nl

func compileFile(jackFile)
    see "Compiling file: " + jackFile + nl
    
    # Create VM output file name
    baseName = getBaseName(jackFile)
    vmOutput = baseName + ".vm"
    
    # Compile to VM
    compileToVM(jackFile, vmOutput)
    
    see "Generated: " + vmOutput + nl

func compileToVM(inputFile, outputFile)
    compilationEngine = new CompilationEngine(inputFile, outputFile)
    compilationEngine.compileClass()
    compilationEngine.close()
