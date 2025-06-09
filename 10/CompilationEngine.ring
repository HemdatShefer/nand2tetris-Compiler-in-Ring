Load "stdlib.ring"
Load "HelperFunctions.ring"

class CompilationEngine
    
    tokenizer outputFile indentLevel
    
    func init(inputFile, outputFile)
        # Load the tokenizer class here to avoid circular dependencies
        Load "JackTokenizer.ring"
        self.tokenizer = new JackTokenizer(inputFile)
        self.outputFile = fopen(outputFile, "w")
        self.indentLevel = 0
        
        if self.outputFile = 0
            see "Error crprocessTokening output file: " + outputFile + nl
        ok

    func writeIndent()
        for i = 1 to indentLevel
            fwrite(outputFile, "  ")
        next

    func writeElement(tag, value)
        self.writeIndent()
        # Handle XML escape sequences
        if value = "<"
            value = "&lt;"
        but value = ">"
            value = "&gt;"
        but value = '"'
            value = "&quot;"
        but value = "&"
            value = "&amp;"
        ok
        
        fwrite(outputFile, "<" + tag + "> " + value + " </" + tag + ">" + nl)

    func writeOpenTag(tag)
        self.writeIndent()
        fwrite(outputFile, "<" + tag + ">" + nl)
        indentLevel++

    func writeCloseTag(tag)
        indentLevel--
        self.writeIndent()
        fwrite(outputFile, "</" + tag + ">" + nl)

    func processToken(expectedToken)
        if tokenizer.getCurrentToken() = expectedToken
            tokenType = tokenizer.tokenType()
            token = tokenizer.getCurrentToken()
            
            if tokenType = "keyword"
                self.writeElement("keyword", token)
            but tokenType = "symbol"
                self.writeElement("symbol", token)
            but tokenType = "identifier"
                self.writeElement("identifier", token)
            but tokenType = "integerConstant"
                self.writeElement("integerConstant", token)
            but tokenType = "stringConstant"
                self.writeElement("stringConstant", token)
            ok
            
            tokenizer.advance()
        else
            see "Expected: " + expectedToken + ", but got: " + tokenizer.getCurrentToken() + nl
        ok

    func compileClass()
        self.writeOpenTag("class")
        
        # Advance to first token
        tokenizer.advance()
        
        # 'class'
        self.processToken("class")
        
        # className
        self.processToken(tokenizer.getCurrentToken())
        
        # '{'
        self.processToken("{")
        
        # classVarDec*
        while tokenizer.getCurrentToken() = "static" or tokenizer.getCurrentToken() = "field"
            self.compileClassVarDec()
        end
        
        # subroutineDec*
        while tokenizer.getCurrentToken() = "constructor" or tokenizer.getCurrentToken() = "function" or tokenizer.getCurrentToken() = "method"
            self.compileSubroutine()
        end
        
        # '}'
        self.processToken("}")
        
        self.writeCloseTag("class")

    func compileClassVarDec()
        self.writeOpenTag("classVarDec")
        
        # ('static' | 'field')
        self.processToken(tokenizer.getCurrentToken())
        
        # type
        self.processToken(tokenizer.getCurrentToken())
        
        # varName
        self.processToken(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.processToken(",")
            self.processToken(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.processToken(";")
        
        self.writeCloseTag("classVarDec")

    func compileSubroutine()
        self.writeOpenTag("subroutineDec")
        
        # ('constructor' | 'function' | 'method')
        self.processToken(tokenizer.getCurrentToken())
        
        # ('void' | type)
        self.processToken(tokenizer.getCurrentToken())
        
        # subroutineName
        self.processToken(tokenizer.getCurrentToken())
        
        # '('
        self.processToken("(")
        
        # parameterList
        self.compileParameterList()
        
        # ')'
        self.processToken(")")
        
        # subroutineBody
        self.compileSubroutineBody()
        
        self.writeCloseTag("subroutineDec")

    func compileParameterList()
        self.writeOpenTag("parameterList")
        
        # Check if parameter list is empty
        if tokenizer.getCurrentToken() != ")"
            # type
            self.processToken(tokenizer.getCurrentToken())
            
            # varName
            self.processToken(tokenizer.getCurrentToken())
            
            # (',' type varName)*
            while tokenizer.getCurrentToken() = ","
                self.processToken(",")
                self.processToken(tokenizer.getCurrentToken()) # type
                self.processToken(tokenizer.getCurrentToken()) # varName
            end
        ok
        
        self.writeCloseTag("parameterList")

    func compileSubroutineBody()
        self.writeOpenTag("subroutineBody")
        
        # '{'
        self.processToken("{")
        
        # varDec*
        while tokenizer.getCurrentToken() = "var"
            self.compileVarDec()
        end
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")
        
        self.writeCloseTag("subroutineBody")

    func compileVarDec()
        self.writeOpenTag("varDec")
        
        # 'var'
        self.processToken("var")
        
        # type
        self.processToken(tokenizer.getCurrentToken())
        
        # varName
        self.processToken(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.processToken(",")
            self.processToken(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.processToken(";")
        
        self.writeCloseTag("varDec")

    func compileStatements()
        self.writeOpenTag("statements")
        
        while tokenizer.getCurrentToken() = "let" or 
              tokenizer.getCurrentToken() = "if" or 
              tokenizer.getCurrentToken() = "while" or 
              tokenizer.getCurrentToken() = "do" or 
              tokenizer.getCurrentToken() = "return"
            
            if tokenizer.getCurrentToken() = "let"
                self.compileLet()
            but tokenizer.getCurrentToken() = "if"
                self.compileIf()
            but tokenizer.getCurrentToken() = "while"
                self.compileWhile()
            but tokenizer.getCurrentToken() = "do"
                self.compileDo()
            but tokenizer.getCurrentToken() = "return"
                self.compileReturn()
            ok
        end
        
        self.writeCloseTag("statements")

    func compileLet()
        self.writeOpenTag("letStatement")
        
        # 'let'
        self.processToken("let")
        
        # varName
        self.processToken(tokenizer.getCurrentToken())
        
        # ('[' expression ']')?
        if tokenizer.getCurrentToken() = "["
            self.processToken("[")
            self.compileExpression()
            self.processToken("]")
        ok
        
        # '='
        self.processToken("=")
        
        # expression
        self.compileExpression()
        
        # ';'
        self.processToken(";")
        
        self.writeCloseTag("letStatement")

    func compileIf()
        self.writeOpenTag("ifStatement")
        
        # 'if'
        self.processToken("if")
        
        # '('
        self.processToken("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.processToken(")")
        
        # '{'
        self.processToken("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")
        
        # ('else' '{' statements '}')?
        if tokenizer.getCurrentToken() = "else"
            self.processToken("else")
            self.processToken("{")
            self.compileStatements()
            self.processToken("}")
        ok
        
        self.writeCloseTag("ifStatement")

    func compileWhile()
        self.writeOpenTag("whileStatement")
        
        # 'while'
        self.processToken("while")
        
        # '('
        self.processToken("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.processToken(")")
        
        # '{'
        self.processToken("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")
        
        self.writeCloseTag("whileStatement")

    func compileDo()
        self.writeOpenTag("doStatement")
        
        # 'do'
        self.processToken("do")
        
        # subroutineCall
        self.compileSubroutineCall()
        
        # ';'
        self.processToken(";")
        
        self.writeCloseTag("doStatement")

    func compileReturn()
        self.writeOpenTag("returnStatement")
        
        # 'return'
        self.processToken("return")
        
        # expression?
        if tokenizer.getCurrentToken() != ";"
            self.compileExpression()
        ok
        
        # ';'
        self.processToken(";")
        
        self.writeCloseTag("returnStatement")

    func compileExpression()
        self.writeOpenTag("expression")
        
        # term
        self.compileTerm()
        
        # (op term)*
        while tokenizer.getCurrentToken() = "+" or 
              tokenizer.getCurrentToken() = "-" or 
              tokenizer.getCurrentToken() = "*" or 
              tokenizer.getCurrentToken() = "/" or 
              tokenizer.getCurrentToken() = "&" or 
              tokenizer.getCurrentToken() = "|" or 
              tokenizer.getCurrentToken() = "<" or 
              tokenizer.getCurrentToken() = ">" or 
              tokenizer.getCurrentToken() = "="
            
            self.processToken(tokenizer.getCurrentToken())
            self.compileTerm()
        end
        
        self.writeCloseTag("expression")

    func compileTerm()
        self.writeOpenTag("term")
        
        currentToken = tokenizer.getCurrentToken()
        tokenType = tokenizer.tokenType()
        
        if tokenType = "integerConstant"
            self.processToken(currentToken)
        but tokenType = "stringConstant"
            self.processToken(currentToken)
        but currentToken = "true" or currentToken = "false" or currentToken = "null" or currentToken = "this"
            self.processToken(currentToken)
        but currentToken = "(" # (expression)
            self.processToken("(")
            self.compileExpression()
            self.processToken(")")
        but currentToken = "-" or currentToken = "~" # unaryOp term
            self.processToken(currentToken)
            self.compileTerm()
        but tokenType = "identifier"
            nextToken = tokenizer.peekToken()
            if nextToken = "["
                # varName[expression]
                self.processToken(currentToken)
                self.processToken("[")
                self.compileExpression()
                self.processToken("]")
            but nextToken = "(" or nextToken = "."
                # subroutineCall
                self.compileSubroutineCall()
            else
                # varName
                self.processToken(currentToken)
            ok
        ok
        
        self.writeCloseTag("term")

    func compileSubroutineCall()
        # subroutineName | (className | varName).subroutineName
        self.processToken(tokenizer.getCurrentToken())
        
        if tokenizer.getCurrentToken() = "."
            self.processToken(".")
            self.processToken(tokenizer.getCurrentToken())
        ok
        
        # '('
        self.processToken("(")
        
        # expressionList
        self.compileExpressionList()
        
        # ')'
        self.processToken(")")

    func compileExpressionList()
        self.writeOpenTag("expressionList")
        
        # Check if expression list is empty
        if tokenizer.getCurrentToken() != ")"
            # expression
            self.compileExpression()
            
            # (',' expression)*
            while tokenizer.getCurrentToken() = ","
                self.processToken(",")
                self.compileExpression()
            end
        ok
        
        self.writeCloseTag("expressionList")

    func close()
        if outputFile != 0
            fclose(outputFile)
        ok
end