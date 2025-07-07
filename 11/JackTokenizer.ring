Load "stdlib.ring"
Load "HelperFunctions.ring"

class JackTokenizer 
    
    file_handle currentLine currentPos tokens currentTokenIndex finished
    
    # Token types
    KEYWORD = "keyword"
    SYMBOL = "symbol" 
    IDENTIFIER = "identifier"
    INT_CONST = "integerConstant"
    STRING_CONST = "stringConstant"
    
    # Keywords
    keywords = ["class", "constructor", "function", "method", "field", "static", 
                "var", "int", "char", "boolean", "void", "true", "false", "null", 
                "this", "let", "do", "if", "else", "while", "return"]
    
    # Symbols
    symbols = ["{", "}", "(", ")", "[", "]", ".", ",", ";", "+", "-", "*", "/", 
               "&", "|", "<", ">", "=", "~"]

    func init(filePath)
        file_handle = fopen(filePath, "r")
        if file_handle = 0
            see "Error opening file: " + filePath + nl
            finished = true
        else
            finished = false
        ok
        
        tokens = []
        currentTokenIndex = 0  # FIXED: Start at 0
        self.tokenizeFile()

    func tokenizeFile()
        fileContent = ""
        
        # Read entire file
        while feof(file_handle) = 0
            line = fgets(file_handle, 1000)
            if line != NULL
                fileContent += string(line)
            ok
        end
        
        fclose(file_handle)
        
        # Remove comments and tokenize
        cleanContent = self.removeComments(fileContent)
        self.parseTokens(cleanContent)

    func removeComments(content)
        result = ""
        i = 1
        inString = false
        
        while i <= len(content)
            ch = substr(content, i, 1)
            
            if ch = '"' and not inString
                inString = true
                result += ch
            but ch = '"' and inString
                inString = false
                result += ch
            but not inString
                # Check for // comments
                if i < len(content) and substr(content, i, 2) = "//"
                    # Skip to end of line
                    while i <= len(content) and substr(content, i, 1) != nl
                        i++
                    end
                    loop
                ok
                
                # Check for /* */ comments
                if i < len(content) and substr(content, i, 2) = "/*"
                    i += 2
                    # Skip until */
                    while i < len(content)
                        if substr(content, i, 2) = "*/"
                            i += 2
                            exit
                        ok
                        i++
                    end
                    loop
                ok
                
                result += ch
            else
                result += ch
            ok
            
            i++
        end
        
        return result

    func parseTokens(content)
        i = 1
        
        while i <= len(content)
            ch = substr(content, i, 1)
            
            # Skip whitespace
            if ch = " " or ch = nl or ch = tab or ascii(ch) = 13
                i++
                loop
            ok
            
            # String constants
            if ch = '"'
                stringToken = ""
                i++ # Skip opening quote
                while i <= len(content) and substr(content, i, 1) != '"'
                    stringToken += substr(content, i, 1)
                    i++
                end
                i++ # Skip closing quote
                add(tokens, [STRING_CONST, stringToken])
                loop
            ok
            
            # Symbols
            if find(symbols, ch) > 0
                add(tokens, [SYMBOL, ch])
                i++
                loop
            ok
            
            # Numbers
            if isdigit(ch)
                numToken = ""
                while i <= len(content) and isdigit(substr(content, i, 1))
                    numToken += substr(content, i, 1)
                    i++
                end
                add(tokens, [INT_CONST, numToken])
                loop
            ok
            
            # Identifiers and keywords
            if isalpha(ch) or ch = "_"
                wordToken = ""
                while i <= len(content) and (isalnum(substr(content, i, 1)) or substr(content, i, 1) = "_")
                    wordToken += substr(content, i, 1)
                    i++
                end
                
                if find(keywords, wordToken) > 0
                    add(tokens, [KEYWORD, wordToken])
                else
                    add(tokens, [IDENTIFIER, wordToken])
                ok
                loop
            ok
            
            i++
        end

    func hasMoreTokens()
        return currentTokenIndex < len(tokens)

    func advance()
        if self.hasMoreTokens()
            currentTokenIndex++
        ok

    func tokenType()
        if currentTokenIndex > 0 and currentTokenIndex <= len(tokens)
            return tokens[currentTokenIndex][1]
        ok
        return ""

    func keyWord()
        if self.tokenType() = KEYWORD
            return tokens[currentTokenIndex][2]
        ok
        return ""

    func symbol()
        if self.tokenType() = SYMBOL
            return tokens[currentTokenIndex][2]
        ok
        return ""

    func identifier()
        if self.tokenType() = IDENTIFIER
            return tokens[currentTokenIndex][2]
        ok
        return ""

    func intVal()
        if self.tokenType() = INT_CONST
            return number(tokens[currentTokenIndex][2])
        ok
        return 0

    func stringVal()
        if self.tokenType() = STRING_CONST
            return tokens[currentTokenIndex][2]
        ok
        return ""

    func getCurrentToken()
        if currentTokenIndex > 0 and currentTokenIndex <= len(tokens)
            return tokens[currentTokenIndex][2]
        ok
        return ""

    func peekToken()
        # FIXED: Better bounds checking
        if currentTokenIndex + 1 <= len(tokens)
            return tokens[currentTokenIndex + 1][2]
        ok
        return ""

    func close()
        # Nothing to close since file is already closed
end
