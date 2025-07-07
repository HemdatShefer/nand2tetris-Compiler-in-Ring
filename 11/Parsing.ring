class parsing

    func init(tokenizer, symbolTable, vmWriter)
        this.tokenizer = tokenizer
        this.symbolTable = symbolTable
        this.vmWriter = vmWriter
    end

    func compileClass()
        tokenizer.advance()
        if tokenizer.token() != "class"
            see "Error: class keyword expected" + nl
            return
        ok

        tokenizer.advance()
        className = tokenizer.token()

        tokenizer.advance()  # Should be '{'
        if tokenizer.token() != "{"
            see "Error: expected '{'" + nl
            return
        ok

        tokenizer.advance()
        while tokenizer.token() = "static" or tokenizer.token() = "field"
            compileClassVarDec()
        end

        while tokenizer.token() = "constructor" or tokenizer.token() = "function" or tokenizer.token() = "method"
            compileSubroutine()
        end

        if tokenizer.token() != "}"
            see "Error: expected '}' at end of class" + nl
        ok
    end


func compileClassVarDec()
    kind = tokenizer.token()  # static or field
    tokenizer.advance()
    
    type = tokenizer.token()  # int, char, boolean, or identifier
    tokenizer.advance()

    name = tokenizer.token()  # varName
    symbolTable.define(name, type, kind)
    tokenizer.advance()

    while tokenizer.token() = ","
        tokenizer.advance()
        name = tokenizer.token()
        symbolTable.define(name, type, kind)
        tokenizer.advance()
    end

    if tokenizer.token() != ";"
        see "Error: expected ';' after class var declaration" + nl
    ok
    tokenizer.advance()
end


func compileSubroutine()
    symbolTable.startSubroutine()

    subroutineType = tokenizer.token()  # constructor/function/method
    tokenizer.advance()

    returnType = tokenizer.token()
    tokenizer.advance()

    subroutineName = tokenizer.token()
    tokenizer.advance()

    tokenizer.advance()  # (
    compileParameterList()
    tokenizer.advance()  # )

    compileSubroutineBody(subroutineName)
end
