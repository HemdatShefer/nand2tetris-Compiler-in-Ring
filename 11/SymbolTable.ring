class SymbolTable
    classScope = []
    subroutineTable = []
    counters = []

    # Constructor to initialize the symbol table
    func init()
        classScope = []
        subroutineTable = []
        counters = []
        counters["static"] = 0
        counters["field"] = 0
        counters["argument"] = 0
        counters["local"] = 0
    end

    # Reset subroutine scope
    func startSubroutine()
        subroutineTable = []
        counters["argument"] = 0
        counters["local"] = 0
    end

    # Define a new identifier
    func define(name, type, kind)
        kind = lower(kind)
        name = lower(name)
        type = lower(type)
        index = counters[kind]
        entry = [type, kind, index]

        if kind = "static" or kind = "field"
            classScope[name] = entry
        else
            subroutineTable[name] = entry
        ok

        counters[kind]++
    end

    # Return the count of identifiers of a specific kind
    func varCount(kind)
        kind = lower(kind)
        return counters[kind]
    end

	# Return the type of a given identifier
    func typeOf(name)
        name = lower(name)

        if isnull(subroutineTable[name]) = false
            return subroutineTable[name][1]
        ok

        if isnull(classScope[name]) = false
            return classScope[name][1]
        ok

        return ""
    end

    # Return the kind of a given identifier
    func kindOf(name)
        name = lower(name)

        if isnull(subroutineTable[name]) = false
            return subroutineTable[name][2]
        ok

        if isnull(classScope[name]) = false
            return classScope[name][2]
        ok

        return "NONE"
    end


    # Return the index of a given identifier
    func indexOf(name)
        name = lower(name)

        if isnull(subroutineTable[name]) = false
            return subroutineTable[name][3]
        ok

        if isnull(classScope[name]) = false
            return classScope[name][3]
        ok

        return -1
    end
