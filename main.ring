Load "Parser.ring"
Load "CodeWriter.ring"
    
func main()
    #################
    # BasicTest.vm
    #################
    filePath = "C:\Users\zlevy\IdeaProjects\Ekronot\7\MemoryAccess\BasicTest"
    outputFile = "BasicTest.asm"      

    parser = new Parser(filePath)
    codeWriter = new CodeWriter(outputFile) # supposed to be located here :filePath

    while parser.hasMoreCommands()
        parser.advance()
        
        cmdType = parser.commandType()

        if cmdType = "C_ARITHMETIC"      # Changed == to = for comparison
            command = parser.arg1()
            codeWriter.writeArithmetic(command)
        but cmdType = "C_PUSH" or cmdType = "C_POP"   # Changed elseif to but, and == to =
            segment = parser.arg1()
            index = parser.arg2()
            codeWriter.writePushPop(cmdType, segment, index)
        ok   # Changed end to ok
    end

    codeWriter.close()

    see "Assembly code has been written to " + outputFile + nl
end