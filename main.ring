Load "Parser.ring"
Load "CodeWriter.ring"

func main(){
    
    /////////////////
    // BasicTest.vm
    ////////////////
    filePath = "C:\Users\zlevy\IdeaProjects\Ekronot\7\MemoryAccess\BasicTest"
    outputFile = "BasicTest.asm"      

    parser = Parser()
    codeWriter = CodeWriter()

    parser.init(filePath)
    
    codeWriter.init(outputFile) //supposed to be located here :filePath

    while parser.hasMoreCommands()
        parser.advance()
        
        cmdType = parser.commandType()

        if cmdType == "C_ARITHMETIC"
            command = parser.arg1()
            codeWriter.writeArithmetic(command)
        elseif cmdType == "C_PUSH" or cmdType == "C_POP"
            segment = parser.arg1()
            index = parser.arg2()
            codeWriter.writePushPop(cmdType, segment, index)
        end
    end

    codeWriter.close()

    see "Assembly code has been written to " + outputFile + nl

}