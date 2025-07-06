class SymbolTable
    classScope = []
    subroutineScope = []
    counters = []

    # Constructor - Called when a new class begins
    func init()
        classScope = []
        subroutineScope = []
        counters = []
        counters["static"] = 0
        counters["field"] = 0
        counters["argument"] = 0
        counters["local"] = 0
    end

    # Start a new subroutine scope - Called at the beginning of each method/function/constructor
    func startSubroutine()
        subroutineScope = []
        counters["argument"] = 0
        counters["local"] = 0
    end

    # Define a new identifier with name, type and kind. Assign it a running index.
    func define(name, type, kind)
        kind = lower(kind)
        name = lower(name)
        type = lower(type)

        index = counters[kind]
        entry = [type, kind, index]

        if kind = "static" or kind = "field"
            classScope[name] = entry
        else
            subroutineScope[name] = entry
        ok

        counters[kind]++
    end

    # Return number of variables of a given kind already defined
    func varCount(kind)
        kind = lower(kind)
        return counters[kind]
    end

    # Return kind of the identifier (field, static, local, argument), or "NONE" if not found
    func kindOf(name)
        name = lower(name)
        if isnull(subroutineScope[name]) = false
            return subroutineScope[name][2]
        ok
        if isnull(classScope[name]) = false
            return classScope[name][2]
        ok
        return "NONE"
    end

    # Return type of the identifier, or "" if not found
    func typeOf(name)
        name = lower(name)
        if isnull(subroutineScope[name]) = false
            return subroutineScope[name][1]
        ok
        if isnull(classScope[name]) = false
            return classScope[name][1]
        ok
        return ""
    end

    # Return index of the identifier, or -1 if not found
    func indexOf(name)
        name = lower(name)
        if isnull(subroutineScope[name]) = false
            return subroutineScope[name][3]
        ok
        if isnull(classScope[name]) = false
            return classScope[name][3]
        ok
        return -1
    end
