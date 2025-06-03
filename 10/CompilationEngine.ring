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
            see "Error creating output file: " + outputFile + nl
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

    func eat(expectedToken)
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
        self.eat("class")
        
        # className
        self.eat(tokenizer.getCurrentToken())
        
        # '{'
        self.eat("{")
        
        # classVarDec*
        while tokenizer.getCurrentToken() = "static" or tokenizer.getCurrentToken() = "field"
            self.compileClassVarDec()
        end
        
        # subroutineDec*
        while tokenizer.getCurrentToken() = "constructor" or tokenizer.getCurrentToken() = "function" or tokenizer.getCurrentToken() = "method"
            self.compileSubroutine()
        end
        
        # '}'
        self.eat("}")
        
        self.writeCloseTag("class")

    func compileClassVarDec()
        self.writeOpenTag("classVarDec")
        
        # ('static' | 'field')
        self.eat(tokenizer.getCurrentToken())
        
        # type
        self.eat(tokenizer.getCurrentToken())
        
        # varName
        self.eat(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.eat(",")
            self.eat(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.eat(";")
        
        self.writeCloseTag("classVarDec")

    func compileSubroutine()
        self.writeOpenTag("subroutineDec")
        
        # ('constructor' | 'function' | 'method')
        self.eat(tokenizer.getCurrentToken())
        
        # ('void' | type)
        self.eat(tokenizer.getCurrentToken())
        
        # subroutineName
        self.eat(tokenizer.getCurrentToken())
        
        # '('
        self.eat("(")
        
        # parameterList
        self.compileParameterList()
        
        # ')'
        self.eat(")")
        
        # subroutineBody
        self.compileSubroutineBody()
        
        self.writeCloseTag("subroutineDec")

    func compileParameterList()
        self.writeOpenTag("parameterList")
        
        # Check if parameter list is empty
        if tokenizer.getCurrentToken() != ")"
            # type
            self.eat(tokenizer.getCurrentToken())
            
            # varName
            self.eat(tokenizer.getCurrentToken())
            
            # (',' type varName)*
            while tokenizer.getCurrentToken() = ","
                self.eat(",")
                self.eat(tokenizer.getCurrentToken()) # type
                self.eat(tokenizer.getCurrentToken()) # varName
            end
        ok
        
        self.writeCloseTag("parameterList")

    func compileSubroutineBody()
        self.writeOpenTag("subroutineBody")
        
        # '{'
        self.eat("{")
        
        # varDec*
        while tokenizer.getCurrentToken() = "var"
            self.compileVarDec()
        end
        
        # statements
        self.compileStatements()
        
        # '}'
        self.eat("}")
        
        self.writeCloseTag("subroutineBody")

    func compileVarDec()
        self.writeOpenTag("varDec")
        
        # 'var'
        self.eat("var")
        
        # type
        self.eat(tokenizer.getCurrentToken())
        
        # varName
        self.eat(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.eat(",")
            self.eat(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.eat(";")
        
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
        self.eat("let")
        
        # varName
        self.eat(tokenizer.getCurrentToken())
        
        # ('[' expression ']')?
        if tokenizer.getCurrentToken() = "["
            self.eat("[")
            self.compileExpression()
            self.eat("]")
        ok
        
        # '='
        self.eat("=")
        
        # expression
        self.compileExpression()
        
        # ';'
        self.eat(";")
        
        self.writeCloseTag("letStatement")

    func compileIf()
        self.writeOpenTag("ifStatement")
        
        # 'if'
        self.eat("if")
        
        # '('
        self.eat("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.eat(")")
        
        # '{'
        self.eat("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.eat("}")
        
        # ('else' '{' statements '}')?
        if tokenizer.getCurrentToken() = "else"
            self.eat("else")
            self.eat("{")
            self.compileStatements()
            self.eat("}")
        ok
        
        self.writeCloseTag("ifStatement")

    func compileWhile()
        self.writeOpenTag("whileStatement")
        
        # 'while'
        self.eat("while")
        
        # '('
        self.eat("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.eat(")")
        
        # '{'
        self.eat("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.eat("}")
        
        self.writeCloseTag("whileStatement")

    func compileDo()
        self.writeOpenTag("doStatement")
        
        # 'do'
        self.eat("do")
        
        # subroutineCall
        self.compileSubroutineCall()
        
        # ';'
        self.eat(";")
        
        self.writeCloseTag("doStatement")

    func compileReturn()
        self.writeOpenTag("returnStatement")
        
        # 'return'
        self.eat("return")
        
        # expression?
        if tokenizer.getCurrentToken() != ";"
            self.compileExpression()
        ok
        
        # ';'
        self.eat(";")
        
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
            
            self.eat(tokenizer.getCurrentToken())
            self.compileTerm()
        end
        
        self.writeCloseTag("expression")

    func compileTerm()
        self.writeOpenTag("term")
        
        currentToken = tokenizer.getCurrentToken()
        tokenType = tokenizer.tokenType()
        
        if tokenType = "integerConstant"
            self.eat(currentToken)
        but tokenType = "stringConstant"
            self.eat(currentToken)
        but currentToken = "true" or currentToken = "false" or currentToken = "null" or currentToken = "this"
            self.eat(currentToken)
        but currentToken = "(" # (expression)
            self.eat("(")
            self.compileExpression()
            self.eat(")")
        but currentToken = "-" or currentToken = "~" # unaryOp term
            self.eat(currentToken)
            self.compileTerm()
        but tokenType = "identifier"
            nextToken = tokenizer.peekToken()
            if nextToken = "["
                # varName[expression]
                self.eat(currentToken)
                self.eat("[")
                self.compileExpression()
                self.eat("]")
            but nextToken = "(" or nextToken = "."
                # subroutineCall
                self.compileSubroutineCall()
            else
                # varName
                self.eat(currentToken)
            ok
        ok
        
        self.writeCloseTag("term")

    func compileSubroutineCall()
        # subroutineName | (className | varName).subroutineName
        self.eat(tokenizer.getCurrentToken())
        
        if tokenizer.getCurrentToken() = "."
            self.eat(".")
            self.eat(tokenizer.getCurrentToken())
        ok
        
        # '('
        self.eat("(")
        
        # expressionList
        self.compileExpressionList()
        
        # ')'
        self.eat(")")

    func compileExpressionList()
        self.writeOpenTag("expressionList")
        
        # Check if expression list is empty
        if tokenizer.getCurrentToken() != ")"
            # expression
            self.compileExpression()
            
            # (',' expression)*
            while tokenizer.getCurrentToken() = ","
                self.eat(",")
                self.compileExpression()
            end
        ok
        
        self.writeCloseTag("expressionList")

    func close()
        if outputFile != 0
            fclose(outputFile)
        ok
end