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
        analyzeFile(source)
    else
        # Directory - find all .jack files
        jackFiles = findJackFiles(source)
        see "Found " + len(jackFiles) + " .jack files." + nl
        
        if len(jackFiles) = 0
            see "No .jack files found in the directory." + nl
            return
        ok
        
        for file in jackFiles
            analyzeFile(file)
        next
    ok
    
    see "Jack analysis completed." + nl


func parseFile(inputFile, outputFile)
    compilationEngine = new CompilationEngine(inputFile, outputFile)
    compilationEngine.compileClass()
    compilationEngine.close()


func analyzeFile(jackFile)
    see "Analyzing file: " + jackFile + nl
    
    # Create output file names
    baseName = getBaseName(jackFile)
    tokensOutput = baseName + "T.xml"
    parseOutput = baseName + ".xml"
    
    # Phase 1: Tokenize only (for testing)
    tokenizeOnly(jackFile, tokensOutput)
    
    # Phase 2: Full parsing
    parseFile(jackFile, parseOutput)
    
    see "Generated: " + tokensOutput + nl
    see "Generated: " + parseOutput + nl




func tokenizeOnly(inputFile, outputFile)
    tokenizer = new JackTokenizer(inputFile)
    output = fopen(outputFile, "w")
    
    if output = 0
        see "Error creating output file: " + outputFile + nl
        return
    ok
    
    # Write opening tag
    fwrite(output, "<tokens>" + nl)
    
    # Process all tokens - FIXED: Don't advance before loop
    while tokenizer.hasMoreTokens()
        tokenizer.advance()  # Advance first, then process
        
        tokenType = tokenizer.tokenType()
        token = tokenizer.getCurrentToken()
        
        # Handle XML escape sequences
        if token = "<"
            token = "&lt;"
        but token = ">"
            token = "&gt;"
        but token = '"'
            token = "&quot;"
        but token = "&"
            token = "&amp;"
        ok
        
        fwrite(output, "<" + tokenType + "> " + token + " </" + tokenType + ">" + nl)
    end
    
    # Write closing tag
    fwrite(output, "</tokens>" + nl)
    
    fclose(output)
# Functions findJackFiles and getBaseName are now in HelperFunctions.ring