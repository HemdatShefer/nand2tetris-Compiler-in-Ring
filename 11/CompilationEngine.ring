Load "stdlib.ring"
Load "HelperFunctions.ring"
Load "SymbolTable.ring"
Load "VMWriter.ring"

class CompilationEngine
    
    tokenizer vmWriter symbolTable className currentSubroutineName currentSubroutineType
    labelCounter
    
    func init(inputFile, outputFile)
        # Load the tokenizer class here to avoid circular dependencies
        Load "JackTokenizer.ring"
        self.tokenizer = new JackTokenizer(inputFile)
        self.vmWriter = new VMWriter(outputFile)
        self.symbolTable = new SymbolTable()
        self.className = ""
        self.currentSubroutineName = ""
        self.currentSubroutineType = ""
        self.labelCounter = 0

    func processToken(expectedToken)
        if tokenizer.getCurrentToken() = expectedToken
            tokenizer.advance()
        else
            see "Expected: " + expectedToken + ", but got: " + tokenizer.getCurrentToken() + nl
        ok

    func compileClass()
        # 'class'
        tokenizer.advance()  # Now we're at the first token
        self.processToken("class")
        
        # className - store it for later use
        self.className = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # '{'
        self.processToken("{")
        
        # classVarDec* - Build symbol table for class variables
        while tokenizer.getCurrentToken() = "static" or tokenizer.getCurrentToken() = "field"
            self.compileClassVarDec()
        end
        
        # subroutineDec*
        while tokenizer.getCurrentToken() = "constructor" or tokenizer.getCurrentToken() = "function" or tokenizer.getCurrentToken() = "method"
            self.compileSubroutine()
        end
        
        # '}'
        self.processToken("}")

    func compileClassVarDec()
        # ('static' | 'field')
        kind = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # type
        type = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # varName
        name = tokenizer.getCurrentToken()
        symbolTable.define(name, type, kind)
        self.processToken(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.processToken(",")
            name = tokenizer.getCurrentToken()
            symbolTable.define(name, type, kind)
            self.processToken(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.processToken(";")

    func compileSubroutine()
        # Start new subroutine scope
        symbolTable.startSubroutine()
        
        # ('constructor' | 'function' | 'method')
        self.currentSubroutineType = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # ('void' | type)
        self.processToken(tokenizer.getCurrentToken())
        
        # subroutineName
        self.currentSubroutineName = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # For methods, add 'this' as first argument
        if currentSubroutineType = "method"
            symbolTable.define("this", className, "argument")
        ok
        
        # '('
        self.processToken("(")
        
        # parameterList
        self.compileParameterList()
        
        # ')'
        self.processToken(")")
        
        # subroutineBody
        self.compileSubroutineBody()

    func compileParameterList()
        # Check if parameter list is empty
        if tokenizer.getCurrentToken() != ")"
            # type
            type = tokenizer.getCurrentToken()
            self.processToken(tokenizer.getCurrentToken())
            
            # varName
            name = tokenizer.getCurrentToken()
            symbolTable.define(name, type, "argument")
            self.processToken(tokenizer.getCurrentToken())
            
            # (',' type varName)*
            while tokenizer.getCurrentToken() = ","
                self.processToken(",")
                type = tokenizer.getCurrentToken()
                self.processToken(tokenizer.getCurrentToken()) # type
                name = tokenizer.getCurrentToken()
                symbolTable.define(name, type, "argument")
                self.processToken(tokenizer.getCurrentToken()) # varName
            end
        ok

    func compileSubroutineBody()
        # '{'
        self.processToken("{")
        
        # varDec* - Count local variables first
        while tokenizer.getCurrentToken() = "var"
            self.compileVarDec()
        end
        
        # Now write the function declaration
        nLocals = symbolTable.varCount("local")
        vmWriter.writeFunction(className + "." + currentSubroutineName, nLocals)
        
        # Handle different subroutine types
        if currentSubroutineType = "constructor"
            # Allocate memory for object
            nFields = symbolTable.varCount("field")
            see "Allocating memory for " + nFields + " fields in constructor." + nl
            vmWriter.writePush("constant", nFields)
            vmWriter.writeCall("Memory.alloc", 1)
            vmWriter.writePop("pointer", 0)  # Set THIS
        but currentSubroutineType = "method"
            # Set THIS to first argument
            vmWriter.writePush("argument", 0)
            vmWriter.writePop("pointer", 0)
        ok
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")

    func compileVarDec()
        # 'var'
        self.processToken("var")
        
        # type
        type = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        # varName
        name = tokenizer.getCurrentToken()
        symbolTable.define(name, type, "local")
        self.processToken(tokenizer.getCurrentToken())
        
        # (',' varName)*
        while tokenizer.getCurrentToken() = ","
            self.processToken(",")
            name = tokenizer.getCurrentToken()
            symbolTable.define(name, type, "local")
            self.processToken(tokenizer.getCurrentToken())
        end
        
        # ';'
        self.processToken(";")

    func compileStatements()
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

    func compileLet()
        # 'let'
        self.processToken("let")
        
        # varName
        varName = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        isArray = false
        # ('[' expression ']')?
        if tokenizer.getCurrentToken() = "["
            isArray = true
            # Push array base address
            self.pushVariable(varName)
            
            self.processToken("[")
            self.compileExpression()  # Index expression
            self.processToken("]")
            
            # Calculate array address
            vmWriter.writeArithmetic("add")
        ok
        
        # '='
        self.processToken("=")
        
        # expression
        self.compileExpression()
        
        # ';'
        self.processToken(";")
        
        # Store the value
        if isArray
            # Array assignment: arr[i] = expr
            vmWriter.writePop("temp", 0)     # Save expression result
            vmWriter.writePop("pointer", 1)  # Set THAT to array address
            vmWriter.writePush("temp", 0)    # Restore expression result
            vmWriter.writePop("that", 0)     # Store in array
        else
            # Simple variable assignment
            self.popVariable(varName)
        ok

    func compileIf()
        # 'if'
        self.processToken("if")
        
        # '('
        self.processToken("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.processToken(")")
        
        # Generate labels
        trueLabel = self.getUniqueLabel()
        falseLabel = self.getUniqueLabel()
        endLabel = self.getUniqueLabel()
        
        # If condition is true, goto TRUE_LABEL
        vmWriter.writeIf(trueLabel)
        vmWriter.writeGoto(falseLabel)
        
        # TRUE branch
        vmWriter.writeLabel(trueLabel)
        
        # '{'
        self.processToken("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")
        
        # Jump to end
        vmWriter.writeGoto(endLabel)
        
        # FALSE branch
        vmWriter.writeLabel(falseLabel)
        
        # ('else' '{' statements '}')?
        if tokenizer.getCurrentToken() = "else"
            self.processToken("else")
            self.processToken("{")
            self.compileStatements()
            self.processToken("}")
        ok
        
        # End label
        vmWriter.writeLabel(endLabel)

    func compileWhile()
        # Generate labels
        loopLabel = self.getUniqueLabel()
        endLabel = self.getUniqueLabel()
        
        # Start of loop
        vmWriter.writeLabel(loopLabel)
        
        # 'while'
        self.processToken("while")
        
        # '('
        self.processToken("(")
        
        # expression
        self.compileExpression()
        
        # ')'
        self.processToken(")")
        
        # If condition is false, exit loop
        vmWriter.writeArithmetic("not")
        vmWriter.writeIf(endLabel)
        
        # '{'
        self.processToken("{")
        
        # statements
        self.compileStatements()
        
        # '}'
        self.processToken("}")
        
        # Go back to beginning of loop
        vmWriter.writeGoto(loopLabel)
        
        # End of loop
        vmWriter.writeLabel(endLabel)

    func compileDo()
        # 'do'
        self.processToken("do")
        
        # subroutineCall
        self.compileSubroutineCall()
        
        # ';'
        self.processToken(";")
        
        # Do statements don't use return value, so pop and discard it
        vmWriter.writePop("temp", 0)

    func compileReturn()
        # 'return'
        self.processToken("return")
        
        # expression?
        if tokenizer.getCurrentToken() != ";"
            self.compileExpression()
        else
            # No return value - push 0
            vmWriter.writePush("constant", 0)
        ok
        
        # ';'
        self.processToken(";")
        
        vmWriter.writeReturn()

    func compileExpression()
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
            
            op = tokenizer.getCurrentToken()
            self.processToken(tokenizer.getCurrentToken())
            self.compileTerm()
            
            # Generate VM command for operator
            if op = "+"
                vmWriter.writeArithmetic("add")
            but op = "-"
                vmWriter.writeArithmetic("sub")
            but op = "*"
                vmWriter.writeCall("Math.multiply", 2)
            but op = "/"
                vmWriter.writeCall("Math.divide", 2)
            but op = "&"
                vmWriter.writeArithmetic("and")
            but op = "|"
                vmWriter.writeArithmetic("or")
            but op = "<"
                vmWriter.writeArithmetic("lt")
            but op = ">"
                vmWriter.writeArithmetic("gt")
            but op = "="
                vmWriter.writeArithmetic("eq")
            ok
        end

    func compileTerm()
        currentToken = tokenizer.getCurrentToken()
        tokenType = tokenizer.tokenType()
        
        if tokenType = "integerConstant"
            vmWriter.writePush("constant", number(currentToken))
            self.processToken(currentToken)
        but tokenType = "stringConstant"
            # Handle string constants - create string and push characters
            self.compileStringConstant(currentToken)
            self.processToken(currentToken)
        but currentToken = "true"
            vmWriter.writePush("constant", 0)
            vmWriter.writeArithmetic("not")
            self.processToken(currentToken)
        but currentToken = "false" or currentToken = "null"
            vmWriter.writePush("constant", 0)
            self.processToken(currentToken)
        but currentToken = "this"
            vmWriter.writePush("pointer", 0)
            self.processToken(currentToken)
        but currentToken = "(" # (expression)
            self.processToken("(")
            self.compileExpression()
            self.processToken(")")
        but currentToken = "-" or currentToken = "~" # unaryOp term
            op = currentToken
            self.processToken(currentToken)
            self.compileTerm()
            if op = "-"
                vmWriter.writeArithmetic("neg")
            else
                vmWriter.writeArithmetic("not")
            ok
        but tokenType = "identifier"
            nextToken = tokenizer.peekToken()
            if nextToken = "["
                # Array access: varName[expression]
                varName = currentToken
                self.processToken(currentToken)
                self.processToken("[")
                
                # Push array base address
                self.pushVariable(varName)
                # Compile index expression
                self.compileExpression()
                # Add base + index
                vmWriter.writeArithmetic("add")
                # Set THAT pointer and push array element
                vmWriter.writePop("pointer", 1)
                vmWriter.writePush("that", 0)
                
                self.processToken("]")
            but nextToken = "(" or nextToken = "."
                # subroutineCall
                self.compileSubroutineCall()
            else
                # varName
                self.pushVariable(currentToken)
                self.processToken(currentToken)
            ok
        ok

    func compileStringConstant(str)
        # Create new string object
        vmWriter.writePush("constant", len(str))
        vmWriter.writeCall("String.new", 1)
        
        # Append each character
        for i = 1 to len(str)
            vmWriter.writePush("constant", ascii(substr(str, i, 1)))
            vmWriter.writeCall("String.appendChar", 2)
        next

    func compileSubroutineCall()
        # Get the first identifier
        firstToken = tokenizer.getCurrentToken()
        self.processToken(tokenizer.getCurrentToken())
        
        nArgs = 0
        
        if tokenizer.getCurrentToken() = "."
            # className.functionName or varName.methodName
            self.processToken(".")
            secondToken = tokenizer.getCurrentToken()
            self.processToken(tokenizer.getCurrentToken())
            
            # Check if firstToken is a variable (object) or class name
            kind = symbolTable.kindOf(firstToken)
            if kind != "NONE"
                # It's a variable - method call on object
                self.pushVariable(firstToken)
                nArgs = 1
                type = symbolTable.typeOf(firstToken)
                fullName = type + "." + secondToken
            else
                # It's a class name - static function call
                fullName = firstToken + "." + secondToken
            ok
        else
            # Method call on current object (this.methodName)
            vmWriter.writePush("pointer", 0)  # Push 'this'
            nArgs = 1
            fullName = className + "." + firstToken
        ok
        
        # '('
        self.processToken("(")
        
        # expressionList
        nArgs += self.compileExpressionList()
        
        # ')'
        self.processToken(")")
        
        # Call the function
        vmWriter.writeCall(fullName, nArgs)

    func compileExpressionList()
        nArgs = 0
        
        # Check if expression list is empty
        if tokenizer.getCurrentToken() != ")"
            # expression
            self.compileExpression()
            nArgs = 1
            
            # (',' expression)*
            while tokenizer.getCurrentToken() = ","
                self.processToken(",")
                self.compileExpression()
                nArgs++
            end
        ok
        
        return nArgs

    func pushVariable(varName)
        kind = symbolTable.kindOf(varName)
        index = symbolTable.indexOf(varName)
        
        if kind = "static"
            vmWriter.writePush("static", index)
        but kind = "field"
            vmWriter.writePush("this", index)
        but kind = "argument"
            vmWriter.writePush("argument", index)
        but kind = "local"
            vmWriter.writePush("local", index)
        ok

    func popVariable(varName)
        kind = symbolTable.kindOf(varName)
        index = symbolTable.indexOf(varName)
        
        if kind = "static"
            vmWriter.writePop("static", index)
        but kind = "field"
            vmWriter.writePop("this", index)
        but kind = "argument"
            vmWriter.writePop("argument", index)
        but kind = "local"
            vmWriter.writePop("local", index)
        ok

    func getUniqueLabel()
        labelCounter++
        return "L" + string(labelCounter)

    func close()
        vmWriter.close()
end